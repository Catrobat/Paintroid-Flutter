import 'package:flutter/material.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';

class CursorIcon extends StatelessWidget {
  final Color drawColor;
  final double size;

   const CursorIcon({
    required this.drawColor,
    this.size = 320,
  }) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('tapped'),
      child: SizedBox(
        width: size,
        height: size,
        child: IconSvg(
          path: 'assets/icon/cursor_icon.svg',
          height: size,
          width: size,
        ),
      ),
    );
  }
}
