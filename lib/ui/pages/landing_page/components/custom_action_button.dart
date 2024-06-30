import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';

class CustomActionButton extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final VoidCallback onPressed;
  final String hint;

  const CustomActionButton({
    super.key,
    required this.heroTag,
    required this.icon,
    required this.onPressed,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: PaintroidTheme.of(context).orangeColor,
      foregroundColor: PaintroidTheme.of(context).onSurfaceColor,
      tooltip: hint,
      child: Icon(icon),
      onPressed: () async => onPressed(),
    );
  }
}
