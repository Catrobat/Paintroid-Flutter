import 'package:flutter/material.dart';

class SliderIndicatorPainter extends CustomPainter {
  final double position;
  SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset(position, -1) & Size(6, size.height + 2),
        Paint()
          ..color = const Color.fromARGB(255, 62, 62, 62)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(SliderIndicatorPainter oldDelegate) {
    return true;
  }
}
