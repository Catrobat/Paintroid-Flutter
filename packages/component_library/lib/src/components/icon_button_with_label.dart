// Flutter imports:
import 'package:component_library/component_library.dart';
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
          style: TextStyle(
            fontSize: 10,
            color: PaintroidTheme.of(context).onSurfaceColor,
          ),
        ),
      ],
    );
  }
}
