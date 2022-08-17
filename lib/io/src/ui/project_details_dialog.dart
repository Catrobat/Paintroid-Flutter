import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:paintroid/io/io.dart';

import '../../../data/model/project.dart';
import '../../../ui/color_schemes.dart';
import '../service/image_service.dart';

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

    _getImageDimenstions(widget.project.imagePreviewPath);

    return AlertDialog(
      title: Text(widget.project.name),
      actions: [_okButton],
      content: FutureBuilder(
        future: _getImageDimenstions(widget.project.imagePreviewPath),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final dimensions = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Resolution: ${dimensions[0]} X ${dimensions[1]}"),
                Text("Last edited: ${widget.project.lastModified}"),
                Text("Creation date: ${widget.project.creationDate}"),
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

  ElevatedButton get _okButton => ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text("OK", style: TextStyle(color: Colors.white)),
      );

  int _getProjectSize() {
    return fileService.getFile(widget.project.path).when(
          ok: (file) => file.lengthSync(),
          err: (failure) {
            showToast(failure.message);
            return 0;
          },
        );
  }

  Future<List<int>> _getImageDimenstions(String? path) async {
    List<int> dimensions = [];
    return imageService.getProjectPreview(path).when(
      ok: (img) async {
        final image = await decodeImageFromList(img);
        dimensions.add(image.width);
        dimensions.add(image.height);
        return dimensions;
      },
      err: (failure) {
        showToast(failure.message);
        return dimensions;
      },
    );
  }
}
