// Flutter imports:
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String valueKey;
  final Color? color;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.valueKey,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      key: ValueKey(valueKey),
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? Theme.of(context).colorScheme.background,
    );
  }
}
