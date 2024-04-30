// Flutter imports:
import 'package:flutter/material.dart';

class ToolOption extends StatelessWidget {
  final bool isIgnoring;
  final double opacity;
  final Widget child;
  final Duration duration;

  const ToolOption({
    Key? key,
    required this.isIgnoring,
    required this.opacity,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isIgnoring,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: duration,
        child: child,
      ),
    );
  }
}
