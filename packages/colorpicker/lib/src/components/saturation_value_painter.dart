import 'package:flutter/material.dart';

class SaturationValuePainter extends CustomPainter {
  final double hue;
  final Offset thumbPosition;

  SaturationValuePainter({required this.hue, required this.thumbPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Paint paintWhiteToHue = Paint()
      ..shader = LinearGradient(
        colors: [
          HSVColor.fromAHSV(1.0, hue, 0.0, 1.0).toColor(),
          HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect);
    canvas.drawRect(rect, paintWhiteToHue);

    final Paint paintTransparentToBlack = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Colors.black,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, paintTransparentToBlack);

    final Paint thumbPaintFill = Paint()..color = Colors.white;
    final Paint thumbPaintStroke = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const double thumbRadius = 6.0;

    final double clampedDx =
        thumbPosition.dx.clamp(thumbRadius, size.width - thumbRadius);
    final double clampedDy =
        thumbPosition.dy.clamp(thumbRadius, size.height - thumbRadius);
    final Offset clampedThumbPosition = Offset(clampedDx, clampedDy);

    canvas.drawCircle(clampedThumbPosition, thumbRadius, thumbPaintFill);
    canvas.drawCircle(clampedThumbPosition, thumbRadius, thumbPaintStroke);
  }

  @override
  bool shouldRepaint(SaturationValuePainter oldDelegate) {
    return oldDelegate.hue != hue || oldDelegate.thumbPosition != thumbPosition;
  }
}
