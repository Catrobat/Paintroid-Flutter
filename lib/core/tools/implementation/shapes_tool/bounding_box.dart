import 'dart:math';
import 'dart:ui';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';
import 'package:paintroid/core/extensions/path_extension.dart';
import 'package:paintroid/core/utils/constants.dart';

class BoundingBox {
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
  Offset lastPoint = Offset.zero;

  final anchorRadius = 40.0;
  final padding = GraphicFactory.guidePaint.strokeWidth * 4;
  BoundingBoxCorner activeCorner = BoundingBoxCorner.none;

  BoundingBox(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  Offset get center => Offset(averageX, averageY);

  double get distanceToEdgeFromCenter => center.distanceTo(topEdgeCenter);

  Offset get topEdgeCenter => (topLeft + topRight) / 2;

  double get averageX =>
      (topLeft.dx + topRight.dx + bottomLeft.dx + bottomRight.dx) / 4;

  double get averageY =>
      (topLeft.dy + topRight.dy + bottomLeft.dy + bottomRight.dy) / 4;

  double get topLeftBottomRightDiagonal => topLeft.distanceTo(bottomRight);

  double get topRightBottomLeftDiagonal => topRight.distanceTo(bottomLeft);

  double get topLeftDirection => (topLeft - center).direction;

  double get topRightDirection => (topRight - center).direction;

  double get bottomLeftDirection => (bottomLeft - center).direction;

  double get bottomRightDirection => (bottomRight - center).direction;

  double get outerRadius => (topLeftBottomRightDiagonal / 2);

  double get innerRadius => distanceToEdgeFromCenter - padding;

  double get angle => (topLeft - center).direction;

  double get activeCornerDirection {
    switch (activeCorner) {
      case BoundingBoxCorner.topLeft:
        return topLeftDirection;
      case BoundingBoxCorner.topRight:
        return topRightDirection;
      case BoundingBoxCorner.bottomLeft:
        return bottomLeftDirection;
      case BoundingBoxCorner.bottomRight:
        return bottomRightDirection;
      case BoundingBoxCorner.none:
        return 0;
    }
  }

  void setActiveCorner(Offset point, {bool isRotating = false}) {
    if (point.isWithinRadius(topLeft, anchorRadius)) {
      activeCorner = BoundingBoxCorner.topLeft;
    } else if (point.isWithinRadius(topRight, anchorRadius)) {
      activeCorner = BoundingBoxCorner.topRight;
    } else if (point.isWithinRadius(bottomLeft, anchorRadius)) {
      activeCorner = BoundingBoxCorner.bottomLeft;
    } else if (point.isWithinRadius(bottomRight, anchorRadius)) {
      activeCorner = BoundingBoxCorner.bottomRight;
    } else {
      activeCorner = BoundingBoxCorner.none;
    }
    lastPoint = point;
  }

  void resetActiveCorner() => activeCorner = BoundingBoxCorner.none;

  void update(Offset point, {bool isRotating = false}) {
    if (activeCorner == BoundingBoxCorner.none) {
      moveCenter(center + point - lastPoint);
    } else if (isRotating) {
      rotate(point);
    } else {
      transform(point);
    }
    lastPoint = point;
  }

  void updateCorners(
    Offset topLeft,
    Offset topRight,
    Offset bottomLeft,
    Offset bottomRight, {
    Offset offset = Offset.zero,
  }) {
    this.topLeft = topLeft + offset;
    this.topRight = topRight + offset;
    this.bottomLeft = bottomLeft + offset;
    this.bottomRight = bottomRight + offset;
  }

  void transform(Offset point) {
    switch (activeCorner) {
      case BoundingBoxCorner.topLeft:
        topLeft = point;
        topRight = bottomRight.moveTowards(
          towards: topLeft,
          distance: topLeftBottomRightDiagonal / 2,
          from: (topLeft + bottomRight) / 2.0,
          rotation: -HALF_PI,
        );
        bottomLeft = bottomRight.moveTowards(
          towards: topLeft,
          distance: topLeftBottomRightDiagonal / 2,
          from: (topLeft + bottomRight) / 2,
          rotation: HALF_PI,
        );
        break;
      case BoundingBoxCorner.topRight:
        topRight = point;
        topLeft = bottomLeft.moveTowards(
          towards: topRight,
          distance: topRightBottomLeftDiagonal / 2,
          from: (topRight + bottomLeft) / 2,
          rotation: HALF_PI,
        );
        bottomRight = bottomLeft.moveTowards(
          towards: topRight,
          distance: topRightBottomLeftDiagonal / 2,
          from: (topRight + bottomLeft) / 2,
          rotation: -HALF_PI,
        );
        break;
      case BoundingBoxCorner.bottomLeft:
        bottomLeft = point;
        topLeft = topRight.moveTowards(
          towards: bottomLeft,
          distance: topRightBottomLeftDiagonal / 2,
          from: (topRight + bottomLeft) / 2,
          rotation: -HALF_PI,
        );
        bottomRight = topRight.moveTowards(
          towards: bottomLeft,
          distance: topRightBottomLeftDiagonal / 2,
          from: (topRight + bottomLeft) / 2,
          rotation: HALF_PI,
        );
        break;
      case BoundingBoxCorner.bottomRight:
        bottomRight = point;
        topRight = topLeft.moveTowards(
          towards: bottomRight,
          distance: topLeftBottomRightDiagonal / 2,
          from: (topLeft + bottomRight) / 2,
          rotation: HALF_PI,
        );
        bottomLeft = topLeft.moveTowards(
          towards: bottomRight,
          distance: topLeftBottomRightDiagonal / 2,
          from: (topLeft + bottomRight) / 2,
          rotation: -HALF_PI,
        );
        break;
      case BoundingBoxCorner.none:
        break;
    }
  }

  void rotate(Offset point) {
    if (activeCornerDirection == 0) return;

    final direction = (point - center).direction - activeCornerDirection;

    final topLeftDirection = this.topLeftDirection + direction;
    final topRightDirection = this.topRightDirection + direction;
    final bottomLeftDirection = this.bottomLeftDirection + direction;
    final bottomRightDirection = this.bottomRightDirection + direction;
    final newTopLeft =
        center.move(topLeft.distanceTo(center), topLeftDirection);
    final newTopRight =
        center.move(topRight.distanceTo(center), topRightDirection);
    final newBottomLeft =
        center.move(bottomLeft.distanceTo(center), bottomLeftDirection);
    final newBottomRight =
        center.move(bottomRight.distanceTo(center), bottomRightDirection);

    updateCorners(newTopLeft, newTopRight, newBottomLeft, newBottomRight);
  }

  void moveCenter(Offset point) {
    final offset = Offset(point.dx - center.dx, point.dy - center.dy);
    updateCorners(topLeft, topRight, bottomLeft, bottomRight, offset: offset);
  }

  Offset getPaddedOffset(Offset point, {double padding = 0}) {
    padding += padding > 0 ? this.padding : 0;
    return point.moveTowards(towards: center, distance: -padding);
  }

  Offset getPaddedTopLeft({double padding = 0}) =>
      getPaddedOffset(topLeft, padding: padding);

  Offset getPaddedTopRight({double padding = 0}) =>
      getPaddedOffset(topRight, padding: padding);

  Offset getPaddedBottomLeft({double padding = 0}) =>
      getPaddedOffset(bottomLeft, padding: padding);

  Offset getPaddedBottomRight({double padding = 0}) =>
      getPaddedOffset(bottomRight, padding: padding);

  Path getPath({double padding = 0}) => Path()
    ..moveToOffset(getPaddedTopLeft(padding: padding))
    ..lineToOffset(getPaddedTopRight(padding: padding))
    ..lineToOffset(getPaddedBottomRight(padding: padding))
    ..lineToOffset(getPaddedBottomLeft(padding: padding))
    ..close();

  Path getStarPath(int numberOfPoints, double radius) {
    final path = Path();
    final innerRadius = radius / 2;
    final angleStep = pi / numberOfPoints;
    for (int i = 0; i < numberOfPoints * 2; i++) {
      final currentRadius = (i % 2 == 0) ? radius : innerRadius;
      final currentAngle = i * angleStep + angle;
      final point = Offset(
        center.dx + currentRadius * cos(currentAngle),
        center.dy + currentRadius * sin(currentAngle),
      );
      i == 0 ? path.moveToOffset(point) : path.lineToOffset(point);
    }
    path.close();
    return path;
  }
}
