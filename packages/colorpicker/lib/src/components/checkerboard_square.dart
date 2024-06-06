import 'package:flutter/material.dart';

class CheckerboardSquare extends StatelessWidget {
  const CheckerboardSquare({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'packages/colorpicker/assets/img/checkerboard.png',
        repeat: ImageRepeat.repeat,
        cacheHeight: 16,
        cacheWidth: 16,
        filterQuality: FilterQuality.none,
      ),
    );
  }
}
