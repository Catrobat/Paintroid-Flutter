import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../../data/model/project.dart';

/// Returns [true] if user chose to delete the project or [null] if user
/// dismiss the dialog by tapping outside
Future<bool?> showDetailsDialog(BuildContext context, Project project) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => ProjectDetailsDialog(project: project),
        barrierDismissible: true,
        barrierLabel: "Show project details dialog box");

class ProjectDetailsDialog extends StatefulWidget {
  final Project project;

  const ProjectDetailsDialog({Key? key, required this.project})
      : super(key: key);

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project.name),
      actions: [_okButton],
      content: Column(
        children: [
          Text("resolution: 1080 X 1920"),
          Text("last edited: ${widget.project.lastModified}"),
          Text("creation date: ${widget.project.creationDate}"),
          Text("size: ${_getFileSize()!} B"),
        ],
      ),
    );
  }

  ElevatedButton get _okButton => ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text("OK", style: TextStyle(color: Colors.white)),
      );

  int? _getFileSize() {
    int? size;
    try {
      final file = File(widget.project.path);
      size = file.lengthSync();
    } catch (err, stacktrace) {
      showToast(err.toString());
    }
    return size;
  }
}
