import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:io_library/io_library.dart';

Future<String?> showRenameDialog(BuildContext context, String name) async {
  final TextEditingController textFieldController = TextEditingController()
    ..text = name;

  final formKey = GlobalKey<FormState>(debugLabel: 'TextInputDialog Form');

  return showDialog<String>(
    context: context,
    builder: (context) {
      return GenericDialog(
        title: 'Rename $name',
        actions: [
          GenericDialogAction(
            title: 'CANCEL',
            onPressed: () => Navigator.of(context).pop(),
          ),
          GenericDialogAction(
            title: 'RENAME',
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return null;
              }
              Navigator.of(context).pop(textFieldController.text);
            },
          ),
        ],
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextInputField(
                key: const Key('textInputField'),
                controller: textFieldController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please specify a project name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
