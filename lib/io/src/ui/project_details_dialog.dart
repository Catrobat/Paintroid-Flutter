import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/io/src/ui/delete_project_dialog.dart';

import 'package:paintroid/data/model/project.dart';
import 'package:paintroid/ui/color_schemes.dart';

Future<bool?> showDetailsDialog(BuildContext context, Project project) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => ProjectDetailsDialog(project: project),
        barrierDismissible: true,
        barrierLabel: "Show project details dialog box");

class ProjectDetailsDialog extends ConsumerStatefulWidget {
  final Project project;

  const ProjectDetailsDialog({Key? key, required this.project})
      : super(key: key);

  @override
  ConsumerState<ProjectDetailsDialog> createState() =>
      _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends ConsumerState<ProjectDetailsDialog> {
  late IImageService imageService;
  late IFileService fileService;

  @override
  Widget build(BuildContext context) {
    imageService = ref.watch(IImageService.provider);
    fileService = ref.watch(IFileService.provider);

    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.project.name),
      actions: const [DialogElevatedButton(text: 'OK')],
      content: FutureBuilder(
        future: _getImageDimensions(widget.project.imagePreviewPath),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final dimensions = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Resolution: ${dimensions[0]} X ${dimensions[1]}"),
                Text(
                    "Last modified: ${formatter.format(widget.project.lastModified)}"),
                Text(
                    "Creation date: ${formatter.format(widget.project.creationDate)}"),
                Text("Size: ${filesize(_getProjectSize())}"),
              ],
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  backgroundColor: lightColorScheme.background,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  int _getProjectSize() => fileService.getFile(widget.project.path).when(
        ok: (file) => file.lengthSync(),
        err: (failure) {
          showToast(failure.message);
          return 0;
        },
      );

  Future<List<int>> _getImageDimensions(String? path) async {
    List<int> dimensions = [];
    return imageService.getProjectPreview(path).when(
          ok: (img) => imageService.import(img).when(
            ok: (image) {
              dimensions.add(image.width);
              dimensions.add(image.height);
              return dimensions;
            },
            err: (failure) {
              showToast(failure.message);
              return dimensions;
            },
          ),
          err: (failure) {
            showToast(failure.message);
            return dimensions;
          },
        );
  }
}
