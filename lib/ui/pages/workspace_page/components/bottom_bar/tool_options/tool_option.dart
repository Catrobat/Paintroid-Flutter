import 'package:flutter/material.dart';

class ToolOption extends StatelessWidget {
  final bool isIgnoring;
  final double opacity;
  final Widget child;
  final Duration duration;

  const ToolOption({
    super.key,
    required this.isIgnoring,
    required this.opacity,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

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
