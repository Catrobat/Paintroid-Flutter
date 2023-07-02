import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/data/model/project.dart';
import 'package:paintroid/data/project_database.dart';
import 'package:intl/intl.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/ui/main_overflow_menu.dart';
import 'package:paintroid/ui/project_overflow_menu.dart';
import 'package:paintroid/workspace/src/state/canvas_state_notifier.dart';
import 'package:paintroid/workspace/src/state/workspace_state_notifier.dart';

import 'package:paintroid/ui/color_schemes.dart';
import 'package:paintroid/ui/io_handler.dart';

class LandingPage extends ConsumerStatefulWidget {
  final String title;

  const LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  late ProjectDatabase database;
  late IFileService fileService;
  late IImageService imageService;

  Future<List<Project>> _getProjects() async =>
      database.projectDAO.getProjects();

  void _navigateToPocketPaint() async {
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
          showToast(failure.message);
        }
        return false;
      },
    );
  }

  void _clearCanvas() {
    ref.read(CanvasState.provider.notifier)
      ..clearBackgroundImageAndResetDimensions()
      ..resetCanvasWithNewCommands([]);
    ref.read(WorkspaceState.provider.notifier).updateLastSavedCommandCount();
  }

  void _openProject(Project project, IOHandler ioHandler) async {
    bool loaded = await _loadProject(ioHandler, project);
    if (loaded) _navigateToPocketPaint();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(ProjectDatabase.provider);
    db.when(
      data: (value) => database = value,
      error: (err, stacktrace) => showToast("Error: $err"),
      loading: () {},
    );
    final ioHandler = ref.watch(IOHandler.provider);
    final size = MediaQuery.of(context).size;
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    Project? latestModifiedProject;
    fileService = ref.watch(IFileService.provider);
    imageService = ref.watch(IImageService.provider);

    return Scaffold(
      backgroundColor: lightColorScheme.primary,
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
                SizedBox(
                  height: size.height / 3,
                  child: Stack(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () async {
                            if (latestModifiedProject != null) {
                              _openProject(latestModifiedProject!, ioHandler);
                            }
                          },
                          child: _ImagePreview(
                            project: latestModifiedProject,
                            imageService: imageService,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          key: const Key('myEditIcon'),
                          iconSize: 264,
                          onPressed: () async {
                            if (latestModifiedProject != null) {
                              _openProject(latestModifiedProject!, ioHandler);
                            }
                          },
                          icon: SvgPicture.asset(
                            "assets/svg/ic_edit_circle.svg",
                            height: 264,
                            width: 264,
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
                  ),
                ),
                SizedBox(
                  child: Container(
                    color: lightColorScheme.primaryContainer,
                    width: size.width,
                    padding: const EdgeInsets.all(20),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Projects",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      if (position != 0) {
                        Project project = snapshot.data![position];
                        return Card(
                          child: ListTile(
                            leading: _ImagePreview(
                              project: project,
                              imageService: imageService,
                              width: 80,
                              color: Colors.white,
                            ),
                            dense: false,
                            title: Text(
                              project.name,
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            subtitle: Text(
                              'last modified: ${dateFormat.format(project.lastModified)}',
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            trailing: ProjectOverflowMenu(
                              key: Key('ProjectOverflowMenu Key$position'),
                              project: project,
                            ),
                            enabled: true,
                            onTap: () async => _openProject(project, ioHandler),
                          ),
                        );
                      }
                      return const Card();
                    },
                    itemCount: snapshot.data?.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: lightColorScheme.background,
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _LandingPageFAB(
            heroTag: "import_image",
            icon: Icons.file_download,
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
          _LandingPageFAB(
            heroTag: "new_image",
            icon: Icons.add,
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

class _LandingPageFAB extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final VoidCallback onPressed;

  const _LandingPageFAB({
    Key? key,
    required this.heroTag,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: const Color(0xFFFFAB08),
      foregroundColor: const Color(0xFFFFFFFF),
      child: Icon(icon),
      onPressed: () async => onPressed(),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final Project? project;
  final double? width;
  final Color color;
  final IImageService imageService;

  const _ImagePreview({
    Key? key,
    this.width,
    required this.color,
    this.project,
    required this.imageService,
  }) : super(key: key);

  ImageProvider _getProjectPreviewImageProvider(Uint8List img) =>
      Image.memory(img, fit: BoxFit.cover).image;

  Uint8List? _getProjectPreview(String? path) =>
      imageService.getProjectPreview(path).when(
            ok: (preview) => preview,
            err: (failure) {
              showToast(failure.message);
              return null;
            },
          );

  @override
  Widget build(BuildContext context) {
    Uint8List? img;
    if (project != null) {
      img = _getProjectPreview(project!.imagePreviewPath);
    }
    var imgPreview = BoxDecoration(color: color);
    if (img != null) {
      imgPreview = BoxDecoration(
        color: color,
        image: DecorationImage(
          image: _getProjectPreviewImageProvider(img),
        ),
      );
    }
    if (width != null) {
      return Container(
        width: width!,
        decoration: imgPreview,
      );
    } else {
      return Container(
        decoration: imgPreview,
      );
    }
  }
}
