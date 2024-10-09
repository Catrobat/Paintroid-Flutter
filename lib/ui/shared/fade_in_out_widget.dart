import 'package:flutter/material.dart';

class FadeInOutWidget extends StatelessWidget {
  final bool isVisible;
  final Widget child;

  const FadeInOutWidget({
    super.key,
    required this.isVisible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}
