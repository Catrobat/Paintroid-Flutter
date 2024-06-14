// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

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
            style: PaintroidTheme.of(context).descStyle,
          ),
        ),
      ],
    );
  }
}
