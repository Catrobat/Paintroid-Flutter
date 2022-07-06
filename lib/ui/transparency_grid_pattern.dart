import 'package:flutter/material.dart';

class TransparencyGridPattern extends StatelessWidget {
  final Widget? child;
  final int numberOfSquaresAlongWidth;

  const TransparencyGridPattern(
      {Key? key, this.numberOfSquaresAlongWidth = 50, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: CustomPaint(
          painter: _PatternPainter(numberOfSquaresAlongWidth),
          child: child,
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final int squaresAlongWidth;

  _PatternPainter(this.squaresAlongWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = size.width / squaresAlongWidth;
    final boxPaint = Paint()..color = Colors.grey.shade400;
    canvas.drawPaint(Paint()..color = Colors.white);
    for (var i = 0.0, x = 0; i < size.width; i += squareSize, x++) {
      for (var j = 0.0, y = 0; j < size.height; j += squareSize, y++) {
        if ((x + y) % 2 == 0) {
          continue;
        }
        final rect = Rect.fromLTWH(i, j, squareSize, squareSize);
        canvas.drawRect(rect, boxPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) =>
      squaresAlongWidth != oldDelegate.squaresAlongWidth;
}
