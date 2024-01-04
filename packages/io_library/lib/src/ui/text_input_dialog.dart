import 'package:flutter/material.dart';
import 'package:io_library/io_library.dart';

import 'b.dart';

/// Returns [null] if user dismisses the dialog by tapping outside,
/// [String] with the new project name if user chooses to rename,
/// or [false] if user cancels the renaming process.
Future<String?> showRenameDialog(BuildContext context, String name) async {
  final TextEditingController textFieldController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return TextInputDialog(
        title: 'Rename $name',
        textFieldController: textFieldController,
        actions: [
          GenericDialogActionButton(
            text: 'Cancel',
            onPressed: () {
              return null; // Dismiss the dialog with null
            },
          ),
          GenericDialogActionButton(
            text: 'Rename',
            onPressed: () {
              return textFieldController.text;
            },
          ),
        ],
      );
    },
  );
}
