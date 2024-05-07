// Flutter imports:
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFFFAB08),
      foregroundColor: const Color(0xFFFFFFFF),
      tooltip: hint,
      child: Icon(icon),
      onPressed: () async => onPressed(),
    );
  }
}
