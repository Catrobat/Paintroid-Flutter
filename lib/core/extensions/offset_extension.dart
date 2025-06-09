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

  double distanceToSegment(Offset segmentStart, Offset segmentEnd) {
    final Offset point = this;
    final Offset segmentVector = segmentEnd - segmentStart;
    final double segmentLengthSquared = segmentVector.distanceSquared;
    if (segmentLengthSquared == 0.0) return (point - segmentStart).distance;
    final Offset pointToStartVector = point - segmentStart;
    double projectionFactor = (pointToStartVector.dx * segmentVector.dx +
            pointToStartVector.dy * segmentVector.dy) /
        segmentLengthSquared;
    projectionFactor = max(0, min(1, projectionFactor));
    final Offset closestPointOnSegment =
        segmentStart + segmentVector * projectionFactor;
    return (point - closestPointOnSegment).distance;
  }
}
