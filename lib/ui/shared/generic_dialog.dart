// Flutter imports:
import 'package:flutter/material.dart';

class GenericDialogActionButton extends StatelessWidget {
  final String text;
  final Function? onPressed;

  const GenericDialogActionButton(
      {Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.blue)),
        onPressed: () => {
          if (onPressed != null) {onPressed!()}
        },
        child: Text(text),
      );
}

class GenericDialogAction {
  final Function? onPressed;
  final String title;

  const GenericDialogAction({Key? key, this.onPressed, required this.title});
}

class GenericDialog extends StatelessWidget {
  final String title;
  final String? text;
  final Widget? content;
  final List<GenericDialogAction> actions;

  const GenericDialog(
      {Key? key,
      required this.title,
      this.text,
      this.content,
      required this.actions})
      : super(key: key);

  Widget? getContent() {
    if (content != null) {
      return content;
    }
    if (text != null) {
      return Text(text!, style: const TextStyle(color: Colors.black));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0))),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: actions
            .map((action) => GenericDialogActionButton(
                  text: action.title,
                  onPressed: action.onPressed,
                ))
            .toList(),
        content: getContent(),
      );
}
