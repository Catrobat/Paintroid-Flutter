// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:toast/toast.dart';

// Project imports:
import 'package:paintroid/core/database/project_database.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/providers/object/file_service.dart';
import 'package:paintroid/core/providers/object/image_service.dart';
import 'package:paintroid/core/providers/object/io_handler.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/core/utils/load_image_failure.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/pages/landing_page/components/custom_action_button.dart';
import 'package:paintroid/ui/pages/landing_page/components/image_preview.dart';
import 'package:paintroid/ui/pages/landing_page/components/main_overflow_menu.dart';
import 'package:paintroid/ui/pages/landing_page/components/project_list_tile.dart';
import 'package:paintroid/ui/pages/landing_page/components/project_overflow_menu.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';

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
    ref.read(WorkspaceState.provider.notifier).updateLastSavedCommandCount();
  }

  Future<void> _openProject(
      Project? project, IOHandler ioHandler, WidgetRef ref) async {
    if (project != null) {
      ref.read(WorkspaceState.provider.notifier).performIOTask(() async {
        await ref.read(IDeviceService.sizeProvider.future);
        bool loaded = await _loadProject(ioHandler, project);
        if (loaded) _navigateToPocketPaint();
      });
    }
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

    return Scaffold(
      backgroundColor: PaintroidTheme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.title),
        actions: const [MainOverflowMenu()],
      ),
      body: FutureBuilder(
        future: _getProjects(),
        builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              latestModifiedProject = snapshot.data![0];
            }
            return Column(
              children: [
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
                      if (index != 0) {
                        Project project = snapshot.data![index];
                        return ProjectListTile(
                          project: project,
                          imageService: imageService,
                          index: index,
                          onTap: () async {
                            _clearCanvas();
                            _openProject(project, ioHandler, ref);
                          },
                        );
                      }
                      return Container();
                    },
                    itemCount: snapshot.data?.length,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: PaintroidTheme.of(context).fabBackgroundColor,
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
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
              color: PaintroidTheme.of(context).onSurfaceColor.withOpacity(0.5),
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
