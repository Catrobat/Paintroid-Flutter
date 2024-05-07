// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/shared/images/checkerboard.dart';

class CheckerboardPattern extends StatelessWidget {
  final Widget? child;

  const CheckerboardPattern({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: CheckerboardImage(),
        ),
        if (child != null) child!,
      ],
    );
  }
}
