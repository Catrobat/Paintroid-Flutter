import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class CheckerboardPattern extends StatelessWidget {
  final Widget? child;

  const CheckerboardPattern({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: CheckerboardImg(),
        ),
        if (child != null) child!,
      ],
    );
  }
}
