import 'package:flutter/material.dart';

/// Returns [true] if user chose to discard changes or [null] if user
/// dismissed the dialog by tapping outside
Future<bool?> showDiscardChangesDialog(BuildContext context) =>
    showGeneralDialog<bool>(
        context: context,
        pageBuilder: (_, __, ___) => const DiscardChangesDialog(),
        barrierDismissible: true,
        barrierLabel: "Dismiss discard changes dialog box");

class DiscardChangesDialog extends StatefulWidget {
  const DiscardChangesDialog({Key? key}) : super(key: key);

  @override
  State<DiscardChangesDialog> createState() => _DiscardChangesDialogState();
}

class _DiscardChangesDialogState extends State<DiscardChangesDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Discard changes"),
      actions: [_discardButton, _saveButton],
      content: const Text(
          "You have not saved your last changes. They will be lost!"),
    );
  }

  TextButton get _discardButton {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.red),
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text("Discard"),
    );
  }

  ElevatedButton get _saveButton {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text("Save", style: TextStyle(color: Colors.white)),
    );
  }
}
