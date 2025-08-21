import 'dart:math';
import 'dart:ui';

extension OffsetExtensions on Offset {
  double distanceTo(Offset other) => (this - other).distance;

  bool isWithinRadius(Offset other, double radius) =>
      distanceTo(other) < radius;

  Offset moveTowards({
    required Offset towards,
    required double distance,
    Offset? from,
    double rotation = 0,
  }) =>
      move(distance, (this - towards).direction + rotation, from: from);

  Offset move(double distance, double direction, {Offset? from}) =>
      (from ?? this) + Offset.fromDirection(direction, distance);

  Offset normalized() {
    final double d = distance;
    if (d == 0) return Offset.zero;
    return Offset(dx / d, dy / d);
  }

  Offset localToGlobalRelative(double angle) {
    final double cosA = cos(angle);
    final double sinA = sin(angle);
    final double globalX = dx * cosA - dy * sinA;
    final double globalY = dx * sinA + dy * cosA;
    return Offset(globalX, globalY);
  }

  Offset globalToLocal(Offset center, double angle) {
    final Offset relativeToCenter = this - center;
    final double cosA = cos(-angle);
    final double sinA = sin(-angle);
    final double localX =
        relativeToCenter.dx * cosA - relativeToCenter.dy * sinA;
    final double localY =
        relativeToCenter.dx * sinA + relativeToCenter.dy * cosA;
    return Offset(localX, localY);
  }

  Offset localToGlobal(Offset center, double angle) {
    final double cosA = cos(angle);
    final double sinA = sin(angle);
    final double globalX = dx * cosA - dy * sinA;
    final double globalY = dx * sinA + dy * cosA;
    return Offset(globalX, globalY) + center;
  }
}
