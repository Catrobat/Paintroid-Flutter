import 'dart:ui';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';

class BoundingBox {
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;

  double boundingBoxCornerRadius = 60;
  double padding = GraphicFactory.boundingBoxPaint.strokeWidth;
  BoundingBoxCorner activeCorner = BoundingBoxCorner.none;

  BoundingBox(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  Offset get center => Offset(averageX, averageY);

  double get distanceToEdgeFromCenter => center.distanceTo(topEdgeCenter);

  Offset get topEdgeCenter => (topLeft + topRight) / 2;

  double get averageX =>
      (topLeft.dx + topRight.dx + bottomLeft.dx + bottomRight.dx) / 4;

  double get averageY =>
      (topLeft.dy + topRight.dy + bottomLeft.dy + bottomRight.dy) / 4;

  double get width => (topRight.dx - topLeft.dx).abs();
  double get height => (bottomLeft.dy - topLeft.dy).abs();

  double get activeCornerDirection {
    switch (activeCorner) {
      case BoundingBoxCorner.topLeft:
        return (topLeft - center).direction;
      case BoundingBoxCorner.topRight:
        return (topRight - center).direction;
      case BoundingBoxCorner.bottomLeft:
        return (bottomLeft - center).direction;
      case BoundingBoxCorner.bottomRight:
        return (bottomRight - center).direction;
      case BoundingBoxCorner.none:
        return 0;
    }
  }

  void setActiveCorner(Offset point, {bool isRotating = false}) {
    if (point.isWithinRadius(topLeft, boundingBoxCornerRadius)) {
      activeCorner = BoundingBoxCorner.topLeft;
    } else if (point.isWithinRadius(topRight, boundingBoxCornerRadius)) {
      activeCorner = BoundingBoxCorner.topRight;
    } else if (point.isWithinRadius(bottomLeft, boundingBoxCornerRadius)) {
      activeCorner = BoundingBoxCorner.bottomLeft;
    } else if (point.isWithinRadius(bottomRight, boundingBoxCornerRadius)) {
      activeCorner = BoundingBoxCorner.bottomRight;
    } else {
      if (isRotating) {
        moveCenter(point);
      } else {
        update(point);
      }
    }
  }

  void resetActiveCorner() => activeCorner = BoundingBoxCorner.none;

  void update(Offset point, {bool isRotating = false}) {
    if (activeCorner == BoundingBoxCorner.none) {
      moveCenter(point);
    } else if (isRotating) {
      rotate(point);
    } else {
      transform(point);
    }
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
        bottomLeft = Offset(topLeft.dx, bottomRight.dy);
        topRight = Offset(bottomRight.dx, topLeft.dy);
        break;
      case BoundingBoxCorner.topRight:
        topRight = point;
        bottomRight = Offset(topRight.dx, bottomLeft.dy);
        topLeft = Offset(bottomLeft.dx, topRight.dy);
        break;
      case BoundingBoxCorner.bottomLeft:
        bottomLeft = point;
        topLeft = Offset(bottomLeft.dx, topRight.dy);
        bottomRight = Offset(topRight.dx, bottomLeft.dy);
        break;
      case BoundingBoxCorner.bottomRight:
        bottomRight = point;
        topRight = Offset(bottomRight.dx, topLeft.dy);
        bottomLeft = Offset(topLeft.dx, bottomRight.dy);
        break;
      case BoundingBoxCorner.none:
        break;
    }
  }

  void rotate(Offset point) {}

  void moveCenter(Offset point) {
    final offset = Offset(point.dx - center.dx, point.dy - center.dy);
    updateCorners(topLeft, topRight, bottomLeft, bottomRight, offset: offset);
  }

  double getPaddedRadius({double padding = 0}) =>
      distanceToEdgeFromCenter - padding - this.padding;

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

  Path getPath({double padding = 0}) {
    final topLeft = getPaddedTopLeft(padding: padding);
    final topRight = getPaddedTopRight(padding: padding);
    final bottomLeft = getPaddedBottomLeft(padding: padding);
    final bottomRight = getPaddedBottomRight(padding: padding);
    return Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();
  }
}
