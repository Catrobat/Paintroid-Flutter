import 'package:flutter/material.dart';
import 'package:colorpicker/src/constants/color_picker_constants.dart';

class ColorWheelPainter extends CustomPainter {
  final double radius;

  ColorWheelPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final huePaint = Paint()
      ..shader = hueSweepGradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, huePaint);

    final saturationGradient = RadialGradient(
      colors: [
        Colors.white,
        Colors.white.withAlpha(0),
      ],
      stops: const [0.0, 1.0],
    );

    final saturationPaint = Paint()
      ..shader = saturationGradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, saturationPaint);
  }

  @override
  bool shouldRepaint(ColorWheelPainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}
