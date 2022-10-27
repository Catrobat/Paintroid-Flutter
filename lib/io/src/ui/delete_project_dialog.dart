import 'package:flutter/material.dart';

/// Returns [true] if user chose to delete the project or [null] if user
/// dismiss the dialog by tapping outside
Future<bool?> showDeleteDialog(BuildContext context, String name) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => DeleteProjectDialog(name: name),
        barrierDismissible: true,
        barrierLabel: "Show delete project dialog box");

class DeleteProjectDialog extends StatefulWidget {
  final String name;

  const DeleteProjectDialog({Key? key, required this.name}) : super(key: key);

  @override
  State<DeleteProjectDialog> createState() => _DeleteProjectDialogState();
}

class _DeleteProjectDialogState extends State<DeleteProjectDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text("Delete ${widget.name}"),
        actions: [_discardButton, _deleteButton],
        content: const Text("Do you really want to delete your project?"),
      );

  TextButton get _deleteButton {
    return TextButton(
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text("Delete"),
    );
  }

  ElevatedButton get _discardButton => ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.white),
        ),
      );
}
