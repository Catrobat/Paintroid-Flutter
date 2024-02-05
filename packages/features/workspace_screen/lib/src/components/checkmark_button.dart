import 'package:flutter/material.dart';

class CheckMarkButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CheckMarkButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.background,
    );
  }
}
