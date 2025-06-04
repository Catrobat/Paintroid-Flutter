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
}
