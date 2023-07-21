import 'package:flutter/material.dart';

class CheckerboardPattern extends StatelessWidget {
  final Widget? child;

  const CheckerboardPattern({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/img/checkerboard.png',
            repeat: ImageRepeat.repeat,
            cacheWidth: 50,
            cacheHeight: 50,
            filterQuality: FilterQuality.none,
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
