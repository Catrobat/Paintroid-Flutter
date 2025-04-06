import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/core/database/project_database.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/providers/object/file_service.dart';
import 'package:paintroid/core/providers/object/image_service.dart';
import 'package:paintroid/core/providers/object/io_handler.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/core/providers/object/search_filter_sort_provider.dart';
import 'package:paintroid/core/utils/load_image_failure.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/pages/landing_page/components/custom_action_button.dart';
import 'package:paintroid/ui/pages/landing_page/components/image_preview.dart';
import 'package:paintroid/ui/pages/landing_page/components/main_overflow_menu.dart';
import 'package:paintroid/ui/pages/landing_page/components/project_list_tile.dart';
import 'package:paintroid/ui/pages/landing_page/components/project_overflow_menu.dart';
import 'package:paintroid/ui/pages/landing_page/components/search_toggle_button.dart';
import 'package:paintroid/ui/pages/landing_page/components/search_text_field.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';
import 'package:paintroid/core/models/sort_option.dart';
import 'package:toast/toast.dart';

class LandingPage extends ConsumerStatefulWidget {
  final String title;

  const LandingPage({super.key, required this.title});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  late ProjectDatabase database;
  late IFileService fileService;
  late IImageService imageService;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<List<Project>> _getProjects() async {
    return database.projectDAO.getProjects();
  }

  Future<void> _navigateToPocketPaint() async {
    await Navigator.pushNamed(context, '/PocketPaint');
    setState(() {});
  }

  Future<bool> _loadProject(IOHandler ioHandler, Project project) async {
    project.lastModified = DateTime.now();
    await database.projectDAO.insertProject(project);
    return fileService.getFile(project.path).when(
      ok: (file) async {
        return await ioHandler.loadFromFiles(Result.ok(file));
      },
      err: (failure) {
        if (failure != LoadImageFailure.userCancelled) {
          ToastUtils.showShortToast(message: failure.message);
        }
        return false;
      },
    );
  }

  void _clearCanvas() {
    ref.read(canvasStateProvider.notifier)
      ..clearBackgroundImageAndResetDimensions()
      ..resetCanvasWithNewCommands([]);
    ref.read(workspaceStateProvider.notifier).updateLastSavedCommandCount();
  }

  Future<void> _openProject(
      Project? project, IOHandler ioHandler, WidgetRef ref) async {
    if (project != null) {
      ref.read(workspaceStateProvider.notifier).performIOTask(() async {
        await ref.read(IDeviceService.sizeProvider.future);
        bool loaded = await _loadProject(ioHandler, project);
        if (loaded) _navigateToPocketPaint();
      });
    }
  }

  List<Project> _filterProjects(List<Project> projects) {
    List<Project> filteredProjects = projects;
    final searchQuery = ref.watch(searchQueryProvider);
    final sortOption = ref.watch(sortOptionProvider);

    if (searchQuery.isNotEmpty) {
      filteredProjects = filteredProjects
          .where((project) =>
              project.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    filteredProjects.sort((a, b) {
      switch (sortOption) {
        case SortOption.nameAsc:
          return a.name.compareTo(b.name);
        case SortOption.nameDesc:
          return b.name.compareTo(a.name);
        case SortOption.dateModifiedNewest:
          return b.lastModified.compareTo(a.lastModified);
        case SortOption.dateModifiedOldest:
          return a.lastModified.compareTo(b.lastModified);
        case SortOption.dateCreatedNewest:
          return b.creationDate.compareTo(a.creationDate);
        case SortOption.dateCreatedOldest:
          return a.creationDate.compareTo(b.creationDate);
      }
    });

    return filteredProjects;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    final db = ref.watch(ProjectDatabase.provider);
    db.when(
      data: (value) => database = value,
      error: (err, stacktrace) =>
          ToastUtils.showShortToast(message: 'Error: $err'),
      loading: () {},
    );
    final ioHandler = ref.watch(IOHandler.provider);
    Project? latestModifiedProject;
    fileService = ref.watch(IFileService.provider);
    imageService = ref.watch(IImageService.provider);

    final isSearchActive = ref.watch(searchActiveProvider);
    final currentSortOption = ref.watch(sortOptionProvider);

    return Scaffold(
      backgroundColor: PaintroidTheme.of(context).primaryColor,
      appBar: AppBar(
        title: isSearchActive
            ? SearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                currentSortOption: currentSortOption,
                onSortOptionSelected: (option) {
                  ref.read(sortOptionProvider.notifier).state = option;
                },
              )
            : Text(widget.title),
        actions: [
          SearchToggleButton(
            isSearchActive: isSearchActive,
            onSearchStart: () {
              ref.read(searchActiveProvider.notifier).state = true;
            },
            onSearchEnd: () {
              ref.read(searchActiveProvider.notifier).state = false;
              ref.read(searchQueryProvider.notifier).state = '';
              _searchController.clear();
            },
          ),
          if (!isSearchActive) const MainOverflowMenu(),
        ],
      ),
      body: FutureBuilder(
        future: _getProjects(),
        builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !isSearchActive) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: PaintroidTheme.of(context).fabBackgroundColor,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final filteredProjects = _filterProjects(snapshot.data!);
            if (filteredProjects.isNotEmpty) {
              latestModifiedProject = filteredProjects[0];
            }
            return Column(
              children: [
                if (!isSearchActive)
                  Flexible(
                    flex: 2,
                    child: _ProjectPreview(
                        ioHandler: ioHandler,
                        imageService: imageService,
                        latestModifiedProject: latestModifiedProject,
                        onProjectPreviewTap: () {
                          if (latestModifiedProject != null) {
                            _openProject(latestModifiedProject, ioHandler, ref);
                          } else {
                            _clearCanvas();
                            _navigateToPocketPaint();
                          }
                        }),
                  ),
                Container(
                  color: PaintroidTheme.of(context).primaryContainerColor,
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Projects',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: PaintroidTheme.of(context).onSurfaceColor,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container();
                      }
                      Project project = filteredProjects[index];
                      return ProjectListTile(
                        project: project,
                        imageService: imageService,
                        index: index,
                        onTap: () async {
                          _clearCanvas();
                          _openProject(project, ioHandler, ref);
                        },
                      );
                    },
                    itemCount: filteredProjects.length,
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: isSearchActive
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomActionButton(
                  heroTag: 'import_image',
                  icon: Icons.file_download,
                  hint: 'Load image',
                  onPressed: () async {
                    final bool imageLoaded =
                        await ioHandler.loadImage(context, this, false);
                    if (imageLoaded && mounted) {
                      _navigateToPocketPaint();
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomActionButton(
                  key: const ValueKey(WidgetIdentifier.newImageActionButton),
                  heroTag: 'new_image',
                  icon: Icons.add,
                  hint: 'New image',
                  onPressed: () async {
                    _clearCanvas();
                    _navigateToPocketPaint();
                  },
                ),
              ],
            ),
    );
  }
}

class _ProjectPreview extends StatelessWidget {
  final Project? latestModifiedProject;
  final IOHandler ioHandler;
  final IImageService imageService;
  final VoidCallback onProjectPreviewTap;

  const _ProjectPreview({
    this.latestModifiedProject,
    required this.ioHandler,
    required this.imageService,
    required this.onProjectPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: InkWell(
            onTap: onProjectPreviewTap,
            child: ImagePreview(
              project: latestModifiedProject,
              imageService: imageService,
              color: PaintroidTheme.of(context)
                  .onSurfaceColor
                  .withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: IconButton(
            key: const Key('myEditIcon'),
            iconSize: 264,
            onPressed: () async {
              onProjectPreviewTap.call();
            },
            icon: latestModifiedProject == null
                ? Container(
                    height: 170.0,
                    width: 170.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PaintroidTheme.of(context)
                            .outlineColor
                            .withAlpha(180)),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: PaintroidTheme.of(context).backgroundColor,
                        size: 150.0,
                      ),
                    ),
                  )
                : const IconSvg(
                    path: 'assets/svg/ic_edit_circle.svg',
                    height: 264.0,
                    width: 264.0,
                  ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: latestModifiedProject == null
              ? null
              : ProjectOverflowMenu(
                  key: const Key('ProjectOverflowMenu Key0'),
                  project: latestModifiedProject!,
                ),
        ),
      ],
    );
  }
}
