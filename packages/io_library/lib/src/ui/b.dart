import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:io_library/io_library.dart';

class TextInputDialog extends HookConsumerWidget {
  final String title;
  final String? text;
  final List<GenericDialogActionButton> actions;
  final TextEditingController textFieldController;

  const TextInputDialog({
    Key? key,
    required this.title,
    this.text,
    required this.actions,
    required this.textFieldController, // Initialize text field controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>(debugLabel: 'SaveImageDialog Form');

    return AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: actions.map((action) {
          if (action.text == 'Cancel') {
            return GenericDialogActionButton(
              text: action.text,
              onPressed: () {
                Navigator.of(context).pop(textFieldController.text);
              },
            );
          } else {
            return GenericDialogActionButton(
              text: action.text,
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                if (action.onPressed != null) {
                  action.onPressed!();
                }
                Navigator.of(context).pop(textFieldController.text);
              },
            );
          }
        }).toList(),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              text != null
                  ? Text(
                      text!,
                      style: const TextStyle(color: Colors.black),
                    )
                  : const SizedBox.shrink(),
              TextInputField(
                controller: textFieldController,
                hintText: '',
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please specify a project name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ));
  }
}
