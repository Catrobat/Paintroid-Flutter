import 'package:flutter/material.dart';

class IconButtonWithLabel extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const IconButtonWithLabel({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
