// Flutter imports:
import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('PlusButton'),
      icon: const Icon(Icons.add),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.background,
    );
  }
}
