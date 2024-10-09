import 'package:flutter/material.dart';

const Duration animationDuration = Duration(milliseconds: 300);
const double maxAnimationOpacity = 1.0;
const double minAnimationOpacity = 0.0;

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
        opacity: isVisible ? maxAnimationOpacity : minAnimationOpacity,
        duration: animationDuration,
        child: child,
      ),
    );
  }
}
