import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:io_library/io_library.dart';

class TextInputDialog extends StatelessWidget {
  final String title;
  final String? text;
  final List<GenericDialogActionButton> actions;
  final TextEditingController textFieldController;
  final String? hintText;
  final String validatorErrorMsg;

  const TextInputDialog({
    Key? key,
    required this.title,
    this.text,
    required this.actions,
    required this.textFieldController,
    this.hintText,
    required this.validatorErrorMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(debugLabel: 'TextInputDialog Form');

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
                Navigator.of(context).pop(null);
              },
            );
          } else {
            return GenericDialogActionButton(
              text: action.text,
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return null;
                }
                if (action.onPressed != null) {
                  action.onPressed!();
                }
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
                key: const Key('textInputField'),
                controller: textFieldController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return validatorErrorMsg;
                  }
                  return null;
                },
              ),
            ],
          ),
        ));
  }
}
