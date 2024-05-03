// Flutter imports:
import 'package:flutter/material.dart';

class IconButtonWithLabel extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const IconButtonWithLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
        FittedBox(
          child: Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
