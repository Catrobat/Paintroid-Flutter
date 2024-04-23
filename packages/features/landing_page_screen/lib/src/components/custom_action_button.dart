import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final VoidCallback onPressed;
  final String hint;

  const CustomActionButton({
    Key? key,
    required this.heroTag,
    required this.icon,
    required this.onPressed,
    required this.hint,
  }) : super(key: key);

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
