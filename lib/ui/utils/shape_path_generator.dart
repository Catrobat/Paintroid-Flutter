import 'dart:math';
import 'package:flutter/widgets.dart';

class ShapePathUtils {
  static Path generateStarPath({
    required double radiusX,
    required double radiusY,
    required double angle,
    required Offset center,
    required int numberOfPoints,
  }) {
    final path = Path();
    final innerRx = radiusX / 2;
    final innerRy = radiusY / 2;
    final angleStep = pi / numberOfPoints;

    for (int i = 0; i < numberOfPoints * 2; i++) {
      final isOuter = i % 2 == 0;
      final currentLocalRx = isOuter ? radiusX : innerRx;
      final currentLocalRy = isOuter ? radiusY : innerRy;
      final pointRelativeAngle = i * angleStep - (pi / 2);

      double localX = currentLocalRx * cos(pointRelativeAngle);
      double localY = currentLocalRy * sin(pointRelativeAngle);

      double rotatedX = localX * cos(angle) - localY * sin(angle);
      double rotatedY = localX * sin(angle) + localY * cos(angle);

      final point = Offset(
        center.dx + rotatedX,
        center.dy + radiusY/9 + rotatedY,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  static Path generateHeartPath({
    required double width,
    required double height,
    required double angle,
    required Offset center,
  }) {
    Path pathAtOrigin = Path();
    final double w = width / 2;
    final double h = height / 2;

    pathAtOrigin.moveTo(0, -h * 0.25);
    pathAtOrigin.cubicTo(-w, -h * 1.25, -w * 1.25, h * 0.25, 0, h * 0.75);
    pathAtOrigin.cubicTo(w * 1.25, h * 0.25, w, -h * 1.25, 0, -h * 0.25);
    pathAtOrigin.close();

    if (angle != 0.0) {
      final rotationMatrix = Matrix4.identity()..rotateZ(angle);
      pathAtOrigin = pathAtOrigin.transform(rotationMatrix.storage);
    }
    return pathAtOrigin.shift(center);
  }
}
