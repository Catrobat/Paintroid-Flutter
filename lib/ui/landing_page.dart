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
import 'package:paintroid/ui/project_overflow_menu.dart';

import '../workspace/src/state/canvas_state_notifier.dart';
import '../workspace/src/state/workspace_state_notifier.dart';
import 'color_schemes.dart';
import 'io_handler.dart';

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

  Future<List<Project>> _getProjects() async {
    return await database.projectDAO.getProjects();
  }

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

  Uint8List? _getProjectPreview(String? path) =>
      imageService.getProjectPreview(path).when(
            ok: (preview) => preview,
            err: (failure) {
              showToast(failure.message);
              return null;
            },
          );

  ImageProvider _getProjectPreviewImageProvider(Uint8List img) => Image.memory(
        img,
        fit: BoxFit.cover,
      ).image;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(ProjectDatabase.provider);
    db.whenData((value) => database = value);
    final ioHandler = ref.watch(IOHandler.provider);
    fileService = ref.watch(IFileService.provider);
    imageService = ref.watch(IImageService.provider);
    final size = MediaQuery.of(context).size;
    Project? latestModifiedProject;

    return Scaffold(
      backgroundColor: lightColorScheme.primary,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _getProjects(),
        builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.hasData) {
            BoxDecoration bigImg;
            if (snapshot.data!.isNotEmpty) {
              latestModifiedProject = snapshot.data![0];
              Uint8List? img =
                  _getProjectPreview(latestModifiedProject!.imagePreviewPath);
              if (img != null) {
                bigImg = BoxDecoration(
                  color: Colors.white54,
                  image: DecorationImage(
                    image: _getProjectPreviewImageProvider(img),
                  ),
                );
              } else {
                bigImg = const BoxDecoration(color: Colors.white54);
              }
            } else {
              bigImg = const BoxDecoration(color: Colors.white54);
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
                              bool loaded = await _loadProject(
                                ioHandler,
                                latestModifiedProject!,
                              );
                              if (loaded) _navigateToPocketPaint();
                            }
                          },
                          child: Container(
                            decoration: bigImg,
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          iconSize: 264,
                          onPressed: () async {
                            if (latestModifiedProject != null) {
                              bool loaded = await _loadProject(
                                ioHandler,
                                latestModifiedProject!,
                              );
                              if (loaded) _navigateToPocketPaint();
                            }
                          },
                          icon: SvgPicture.asset(
                            "assets/svg/ic_edit_circle.svg",
                            height: 264,
                            width: 264,
                          ),
                        ),
                      )
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
                      Project project = snapshot.data![position];
                      if (project != latestModifiedProject) {
                        BoxDecoration imagePreview;
                        Uint8List? img =
                            _getProjectPreview(project.imagePreviewPath);
                        if (img != null) {
                          imagePreview = BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: _getProjectPreviewImageProvider(img),
                            ),
                          );
                        } else {
                          imagePreview =
                              const BoxDecoration(color: Colors.white);
                        }
                        final DateFormat formatter = DateFormat('dd-MM-yyyy');
                        final String lastModified =
                            formatter.format(project.lastModified);

                        return Card(
                          // margin: const EdgeInsets.all(5),
                          child: ListTile(
                            leading: Container(
                              width: 80,
                              decoration: imagePreview,
                            ),
                            dense: false,
                            title: Text(
                              project.name,
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            subtitle: Text(
                              'last modified: $lastModified',
                              style: const TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            trailing: ProjectOverflowMenu(
                              project: project,
                            ),
                            enabled: true,
                            onTap: () async {
                              bool loaded =
                                  await _loadProject(ioHandler, project);
                              if (loaded) _navigateToPocketPaint();
                            },
                          ),
                        );
                      } else {
                        return const Card();
                      }
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
          FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: const Color(0xFFFFAB08),
            foregroundColor: const Color(0xFFFFFFFF),
            child: const Icon(Icons.file_download),
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
          FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: const Color(0xFFFFAB08),
            foregroundColor: const Color(0xFFFFFFFF),
            child: const Icon(Icons.add),
            onPressed: () async {
              ref.read(CanvasState.provider.notifier)
                ..clearBackgroundImageAndResetDimensions()
                ..resetCanvasWithNewCommands([]);
              ref
                  .read(WorkspaceState.provider.notifier)
                  .updateLastSavedCommandCount();
              _navigateToPocketPaint();
            },
          ),
        ],
      ),
    );
  }
}
