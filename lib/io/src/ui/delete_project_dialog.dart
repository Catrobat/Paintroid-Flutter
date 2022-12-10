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
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Delete ${widget.name}"),
      actions: const [
        DialogElevatedButton(text: 'Cancel'),
        DialogTextButton(text: 'Delete'),
      ],
      content: const Text("Do you really want to delete your project?"),
    );
  }
}

class DialogTextButton extends StatelessWidget {
  final String text;

  const DialogTextButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        style:
            ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(text),
      );
}

class DialogElevatedButton extends StatelessWidget {
  final String text;

  const DialogElevatedButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      );
}
