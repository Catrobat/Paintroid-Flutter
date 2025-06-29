import 'package:flutter/material.dart';
import 'package:colorpicker/src/constants/painter_thumb_constants.dart';

class HueSliderPainter extends CustomPainter {
  final double hueSliderThumbY;

  HueSliderPainter({required this.hueSliderThumbY});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final List<Color> hueColors = List.generate(
      360,
      (i) => HSVColor.fromAHSV(1.0, i.toDouble(), 1.0, 1.0).toColor(),
    );
    final Paint huePaint = Paint()
      ..shader = LinearGradient(
        colors: hueColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, huePaint);

    const double thumbWidthFactor = 0.1;
    const double thumbHeightFactor = 0.05;
    final double thumbHeight = size.height * thumbHeightFactor;
    const Radius thumbRadius = Radius.circular(2.0);

    final Paint thumbPaint = Paint()
      ..color = kThumbFillColor
      ..style = PaintingStyle.fill;
    final Paint thumbBorderPaint = Paint()
      ..color = kThumbStrokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = kHueSliderThumbStrokeWidth;

    final double clampedThumbY =
        hueSliderThumbY.clamp(thumbHeight / 2, size.height - (thumbHeight / 2));

    final Rect thumbRect = Rect.fromCenter(
        center: Offset(size.width / 2, clampedThumbY),
        width: size.width + (size.width * thumbWidthFactor),
        height: thumbHeight);

    final RRect thumbRRect = RRect.fromRectAndRadius(thumbRect, thumbRadius);
    canvas.drawRRect(thumbRRect, thumbPaint);
    canvas.drawRRect(thumbRRect, thumbBorderPaint);
  }

  @override
  bool shouldRepaint(HueSliderPainter oldDelegate) {
    return oldDelegate.hueSliderThumbY != hueSliderThumbY;
  }
}
