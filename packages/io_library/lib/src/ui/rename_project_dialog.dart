import 'package:flutter/material.dart';
import 'package:io_library/io_library.dart';

Future<String?> showRenameDialog(BuildContext context, String name) async {
  final TextEditingController textFieldController = TextEditingController()
    ..text = name;

  return showDialog<String>(
    context: context,
    builder: (context) {
      return TextInputDialog(
        title: 'Rename $name',
        textFieldController: textFieldController,
        actions: [
          GenericDialogActionButton(
            text: 'Cancel',
            onPressed: () {},
          ),
          GenericDialogActionButton(
            text: 'Rename',
            onPressed: () {
              Navigator.of(context).pop(textFieldController.text);
            },
          ),
        ],
        validatorErrorMsg: 'Please specify a project name',
      );
    },
  );
}
