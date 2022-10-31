import 'package:flutter/material.dart';
import 'package:paintroid/io/src/ui/delete_project_dialog.dart';

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
    return const AlertDialog(
      title: Text("Discard changes"),
      actions: [
        DialogTextButton(text: 'Discard'),
        DialogElevatedButton(text: 'Save'),
      ],
      content: Text("You have not saved your last changes. They will be lost!"),
    );
  }
}
