import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';
import 'package:paintroid/core/extensions/path_extension.dart';
import 'package:paintroid/ui/utils/shape_path_generator.dart';

class BoundingBox {
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
  Offset lastPoint = Offset.zero;

  final anchorRadius = 40.0;
  final padding = GraphicFactory.guidePaint.strokeWidth * 4;
  BoundingBoxCorner activeCorner = BoundingBoxCorner.none;
  late final double edgeSensitivity;

  double angle;
  double _lastRotationAngle = 0.0;

  BoundingBox(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight,
      {this.angle = 0.0}) {
    edgeSensitivity = anchorRadius * 2;
  }

  double get rotationArcOffset {
    final double minSize = math.min(width, height);
    final double maxSize = math.max(width, height);
    return (minSize * 0.5 + maxSize * 0.5).clamp(20.0, 80.0);
  }

  double get rotationArcHandleRadius {
    final double minSize = math.min(width, height);
    return (minSize * 0.1).clamp(20.0, 50.0);
  }

  void resetToDefaultsAroundCenter({
    required Offset newCenter,
    double defaultWidth = 150.0,
    double defaultHeight = 150.0,
    double defaultAngle = 0.0,
  }) {
    angle = defaultAngle;
    _lastRotationAngle = 0.0;

    final halfWidth = defaultWidth / 2;
    final halfHeight = defaultHeight / 2;

    Offset tl = Offset(newCenter.dx - halfWidth, newCenter.dy - halfHeight);
    Offset tr = Offset(newCenter.dx + halfWidth, newCenter.dy - halfHeight);
    Offset bl = Offset(newCenter.dx - halfWidth, newCenter.dy + halfHeight);
    Offset br = Offset(newCenter.dx + halfWidth, newCenter.dy + halfHeight);

    if (angle != 0.0) {
      final cosAngle = math.cos(angle);
      final sinAngle = math.sin(angle);

      var vector = tl - newCenter;
      topLeft = newCenter +
          Offset(vector.dx * cosAngle - vector.dy * sinAngle,
              vector.dx * sinAngle + vector.dy * cosAngle);
      vector = tr - newCenter;
      topRight = newCenter +
          Offset(vector.dx * cosAngle - vector.dy * sinAngle,
              vector.dx * sinAngle + vector.dy * cosAngle);
      vector = bl - newCenter;
      bottomLeft = newCenter +
          Offset(vector.dx * cosAngle - vector.dy * sinAngle,
              vector.dx * sinAngle + vector.dy * cosAngle);
      vector = br - newCenter;
      bottomRight = newCenter +
          Offset(vector.dx * cosAngle - vector.dy * sinAngle,
              vector.dx * sinAngle + vector.dy * cosAngle);
    } else {
      topLeft = tl;
      topRight = tr;
      bottomLeft = bl;
      bottomRight = br;
    }

    resetActiveCorner();
  }

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

  double get width => topLeft.distanceTo(topRight);

  double get height => topLeft.distanceTo(bottomLeft);

  Offset get topLeftRotationArcCenter =>
      topLeft.move(rotationArcOffset, (topLeft - center).direction);

  Offset get topRightRotationArcCenter =>
      topRight.move(rotationArcOffset, (topRight - center).direction);

  Offset get bottomLeftRotationArcCenter =>
      bottomLeft.move(rotationArcOffset, (bottomLeft - center).direction);

  Offset get bottomRightRotationArcCenter =>
      bottomRight.move(rotationArcOffset, (bottomRight - center).direction);

  double get activeCornerDirection {
    switch (activeCorner) {
      case BoundingBoxCorner.topLeft:
      case BoundingBoxCorner.topLeftRotationArc:
        return topLeftDirection;
      case BoundingBoxCorner.topRight:
      case BoundingBoxCorner.topRightRotationArc:
        return topRightDirection;
      case BoundingBoxCorner.bottomLeft:
      case BoundingBoxCorner.bottomLeftRotationArc:
        return bottomLeftDirection;
      case BoundingBoxCorner.bottomRight:
      case BoundingBoxCorner.bottomRightRotationArc:
        return bottomRightDirection;
      case BoundingBoxCorner.none:
        return 0;
      case BoundingBoxCorner.topEdge:
      case BoundingBoxCorner.bottomEdge:
      case BoundingBoxCorner.leftEdge:
      case BoundingBoxCorner.rightEdge:
        return 0;
    }
  }

  void setActiveCorner(Offset point) {
    if (point.isWithinRadius(
        topLeftRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.topLeftRotationArc;
      _lastRotationAngle = (point - center).direction;
    } else if (point.isWithinRadius(
        topRightRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.topRightRotationArc;
      _lastRotationAngle = (point - center).direction;
    } else if (point.isWithinRadius(
        bottomLeftRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.bottomLeftRotationArc;
      _lastRotationAngle = (point - center).direction;
    } else if (point.isWithinRadius(
        bottomRightRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.bottomRightRotationArc;
      _lastRotationAngle = (point - center).direction;
    } else if (point.isWithinRadius(topLeft, anchorRadius)) {
      activeCorner = BoundingBoxCorner.topLeft;
    } else if (point.isWithinRadius(topRight, anchorRadius)) {
      activeCorner = BoundingBoxCorner.topRight;
    } else if (point.isWithinRadius(bottomLeft, anchorRadius)) {
      activeCorner = BoundingBoxCorner.bottomLeft;
    } else if (point.isWithinRadius(bottomRight, anchorRadius)) {
      activeCorner = BoundingBoxCorner.bottomRight;
    } else {
      double distToTopEdge = point.distanceToSegment(topLeft, topRight);
      double distToBottomEdge =
          point.distanceToSegment(bottomLeft, bottomRight);
      double distToLeftEdge = point.distanceToSegment(topLeft, bottomLeft);
      double distToRightEdge = point.distanceToSegment(topRight, bottomRight);

      if (distToTopEdge <= edgeSensitivity) {
        activeCorner = BoundingBoxCorner.topEdge;
      } else if (distToBottomEdge <= edgeSensitivity) {
        activeCorner = BoundingBoxCorner.bottomEdge;
      } else if (distToLeftEdge <= edgeSensitivity) {
        activeCorner = BoundingBoxCorner.leftEdge;
      } else if (distToRightEdge <= edgeSensitivity) {
        activeCorner = BoundingBoxCorner.rightEdge;
      } else {
        activeCorner = BoundingBoxCorner.none;
      }
    }
    lastPoint = point;
  }

  void rotate(Offset point) {
    if (!(activeCorner == BoundingBoxCorner.topLeftRotationArc ||
        activeCorner == BoundingBoxCorner.topRightRotationArc ||
        activeCorner == BoundingBoxCorner.bottomLeftRotationArc ||
        activeCorner == BoundingBoxCorner.bottomRightRotationArc)) {
      return;
    }

    final double currentAngle = (point - center).direction;

    double rotationDelta = currentAngle - _lastRotationAngle;

    if (rotationDelta > math.pi) {
      rotationDelta -= 2 * math.pi;
    } else if (rotationDelta < -math.pi) {
      rotationDelta += 2 * math.pi;
    }

    angle += rotationDelta;

    final currentTopLeft = topLeft;
    final currentTopRight = topRight;
    final currentBottomLeft = bottomLeft;
    final currentBottomRight = bottomRight;

    final newTopLeft = center.move(currentTopLeft.distanceTo(center),
        (currentTopLeft - center).direction + rotationDelta);
    final newTopRight = center.move(currentTopRight.distanceTo(center),
        (currentTopRight - center).direction + rotationDelta);
    final newBottomLeft = center.move(currentBottomLeft.distanceTo(center),
        (currentBottomLeft - center).direction + rotationDelta);
    final newBottomRight = center.move(currentBottomRight.distanceTo(center),
        (currentBottomRight - center).direction + rotationDelta);

    updateCorners(newTopLeft, newTopRight, newBottomLeft, newBottomRight);

    _lastRotationAngle = currentAngle;
  }

  void scale(Offset point) {
    late final Offset fixed;
    switch (activeCorner) {
      case BoundingBoxCorner.topLeft:
        fixed = bottomRight;
        break;
      case BoundingBoxCorner.topRight:
        fixed = bottomLeft;
        break;
      case BoundingBoxCorner.bottomLeft:
        fixed = topRight;
        break;
      case BoundingBoxCorner.bottomRight:
        fixed = topLeft;
        break;
      case BoundingBoxCorner.none:
      case BoundingBoxCorner.topEdge:
      case BoundingBoxCorner.bottomEdge:
      case BoundingBoxCorner.leftEdge:
      case BoundingBoxCorner.rightEdge:
      case BoundingBoxCorner.topLeftRotationArc:
      case BoundingBoxCorner.topRightRotationArc:
      case BoundingBoxCorner.bottomLeftRotationArc:
      case BoundingBoxCorner.bottomRightRotationArc:
        return;
    }

    final double left = math.min(point.dx, fixed.dx);
    final double right = math.max(point.dx, fixed.dx);
    final double top = math.min(point.dy, fixed.dy);
    final double bottom = math.max(point.dy, fixed.dy);

    updateCorners(Offset(left, top), Offset(right, top), Offset(left, bottom),
        Offset(right, bottom));

    if (point.dx < fixed.dx && point.dy < fixed.dy) {
      activeCorner = BoundingBoxCorner.topLeft;
    } else if (point.dx > fixed.dx && point.dy < fixed.dy) {
      activeCorner = BoundingBoxCorner.topRight;
    } else if (point.dx < fixed.dx && point.dy > fixed.dy) {
      activeCorner = BoundingBoxCorner.bottomLeft;
    } else {
      activeCorner = BoundingBoxCorner.bottomRight;
    }
  }

  void drawBoundingBox(Canvas canvas) {
    final double bbWidth = (topRight - topLeft).distance;
    final double bbHeight = (bottomLeft - topLeft).distance;
    if (bbWidth <= 0 || bbHeight <= 0) return;
    final double rotationAngle = (topRight - topLeft).direction;

    canvas.save();
    canvas.translate(topLeft.dx, topLeft.dy);
    canvas.rotate(rotationAngle);

    final cornerRadius = math.min(bbWidth / 8, bbHeight / 8);
    final double effectiveCornerRadius = cornerRadius > 0 ? cornerRadius : 0.0;

    void drawArrowHead(Offset tip, double direction) {
      final double wingLength = math.min(bbWidth, bbHeight) / 10;
      final double wingAngle = math.pi / 3;

      final Offset leftWing = tip +
          Offset.fromDirection(direction + math.pi - wingAngle, wingLength);
      final Offset rightWing = tip +
          Offset.fromDirection(direction + math.pi + wingAngle, wingLength);

      canvas.drawLine(tip, leftWing, GraphicFactory.thinPaint);
      canvas.drawLine(tip, rightWing, GraphicFactory.thinPaint);
    }

    void drawArcWithArrows(
        Offset center, double startAngle, double sweepAngle) {
      final double radius = effectiveCornerRadius * 3.5;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
      );

      final Offset start = center + Offset.fromDirection(startAngle, radius);
      final Offset end =
          center + Offset.fromDirection(startAngle + sweepAngle, radius);

      drawArrowHead(start, startAngle - math.pi / 2);
      drawArrowHead(end, startAngle + sweepAngle + math.pi / 2);
    }

    final box = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, bbWidth, bbHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(box, GraphicFactory.guideRectanglePaint);
    final double arcExtensionLength = effectiveCornerRadius * 0.5;
    if (effectiveCornerRadius > 0) {
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(effectiveCornerRadius, effectiveCornerRadius),
            radius: effectiveCornerRadius),
        math.pi,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
      );
      canvas.drawLine(
          Offset(effectiveCornerRadius, 0),
          Offset(effectiveCornerRadius + arcExtensionLength, 0),
          GraphicFactory.guideCornerArcEdgePaint);
      canvas.drawLine(
          Offset(0, effectiveCornerRadius),
          Offset(0, effectiveCornerRadius + arcExtensionLength),
          GraphicFactory.guideCornerArcEdgePaint);
      drawArcWithArrows(
        Offset(effectiveCornerRadius - 15, effectiveCornerRadius - 15),
        math.pi,
        math.pi / 2,
      );

      canvas.drawArc(
        Rect.fromCircle(
            center:
                Offset(bbWidth - effectiveCornerRadius, effectiveCornerRadius),
            radius: effectiveCornerRadius),
        -math.pi / 2,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
      );
      canvas.drawLine(
          Offset(bbWidth - effectiveCornerRadius, 0),
          Offset(bbWidth - effectiveCornerRadius - arcExtensionLength, 0),
          GraphicFactory.guideCornerArcEdgePaint);
      canvas.drawLine(
          Offset(bbWidth, effectiveCornerRadius),
          Offset(bbWidth, effectiveCornerRadius + arcExtensionLength),
          GraphicFactory.guideCornerArcEdgePaint);
      drawArcWithArrows(
        Offset(
            bbWidth - effectiveCornerRadius + 15, effectiveCornerRadius - 15),
        -math.pi / 2,
        math.pi / 2,
      );

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(bbWidth - effectiveCornerRadius,
                bbHeight - effectiveCornerRadius),
            radius: effectiveCornerRadius),
        0,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
      );
      canvas.drawLine(
          Offset(bbWidth - effectiveCornerRadius, bbHeight),
          Offset(
              bbWidth - effectiveCornerRadius - arcExtensionLength, bbHeight),
          GraphicFactory.guideCornerArcEdgePaint);
      canvas.drawLine(
          Offset(bbWidth, bbHeight - effectiveCornerRadius),
          Offset(
              bbWidth, bbHeight - effectiveCornerRadius - arcExtensionLength),
          GraphicFactory.guideCornerArcEdgePaint);
      drawArcWithArrows(
        Offset(bbWidth - effectiveCornerRadius + 15,
            bbHeight - effectiveCornerRadius + 15),
        0,
        math.pi / 2,
      );

      canvas.drawArc(
        Rect.fromCircle(
            center:
                Offset(effectiveCornerRadius, bbHeight - effectiveCornerRadius),
            radius: effectiveCornerRadius),
        math.pi / 2,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
      );
      canvas.drawLine(
          Offset(effectiveCornerRadius, bbHeight),
          Offset(effectiveCornerRadius + arcExtensionLength, bbHeight),
          GraphicFactory.guideCornerArcEdgePaint);
      canvas.drawLine(
          Offset(0, bbHeight - effectiveCornerRadius),
          Offset(0, bbHeight - effectiveCornerRadius - arcExtensionLength),
          GraphicFactory.guideCornerArcEdgePaint);
    }
    drawArcWithArrows(
      Offset(effectiveCornerRadius - 15, bbHeight - effectiveCornerRadius + 15),
      math.pi / 2,
      math.pi / 2,
    );

    final double lineLengthFactor = cornerRadius;

    canvas.drawLine(
      Offset(bbWidth / 2 - lineLengthFactor, 0),
      Offset(bbWidth / 2 + lineLengthFactor, 0),
      GraphicFactory.guideCornerArcEdgePaint,
    );

    canvas.drawLine(
      Offset(bbWidth / 2 - lineLengthFactor, bbHeight),
      Offset(bbWidth / 2 + lineLengthFactor, bbHeight),
      GraphicFactory.guideCornerArcEdgePaint,
    );

    canvas.drawLine(
      Offset(0, bbHeight / 2 - lineLengthFactor),
      Offset(0, bbHeight / 2 + lineLengthFactor),
      GraphicFactory.guideCornerArcEdgePaint,
    );

    canvas.drawLine(
      Offset(bbWidth, bbHeight / 2 - lineLengthFactor),
      Offset(bbWidth, bbHeight / 2 + lineLengthFactor),
      GraphicFactory.guideCornerArcEdgePaint,
    );

    canvas.restore();
  }

  void resetActiveCorner() {
    activeCorner = BoundingBoxCorner.none;
    _lastRotationAngle = 0.0;
  }

  void update(Offset point) {
    if (activeCorner == BoundingBoxCorner.none) {
      moveCenter(center + point - lastPoint);
    } else {
      bool isACornerHandle = activeCorner == BoundingBoxCorner.topLeft ||
          activeCorner == BoundingBoxCorner.topRight ||
          activeCorner == BoundingBoxCorner.bottomLeft ||
          activeCorner == BoundingBoxCorner.bottomRight;

      bool isARotationArcHandle =
          activeCorner == BoundingBoxCorner.topLeftRotationArc ||
              activeCorner == BoundingBoxCorner.topRightRotationArc ||
              activeCorner == BoundingBoxCorner.bottomLeftRotationArc ||
              activeCorner == BoundingBoxCorner.bottomRightRotationArc;

      bool isAnEdgeHandle = activeCorner == BoundingBoxCorner.topEdge ||
          activeCorner == BoundingBoxCorner.bottomEdge ||
          activeCorner == BoundingBoxCorner.leftEdge ||
          activeCorner == BoundingBoxCorner.rightEdge;

      if (isACornerHandle) {
        scale(point);
      } else if (isARotationArcHandle) {
        rotate(point);
      } else if (isAnEdgeHandle) {
        transform(point);
      }
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
    final delta = point - lastPoint;

    switch (activeCorner) {
      case BoundingBoxCorner.topEdge:
        _moveEdge(topLeft, topRight, delta);
        break;
      case BoundingBoxCorner.bottomEdge:
        _moveEdge(bottomLeft, bottomRight, delta);
        break;
      case BoundingBoxCorner.leftEdge:
        _moveEdge(topLeft, bottomLeft, delta);
        break;
      case BoundingBoxCorner.rightEdge:
        _moveEdge(topRight, bottomRight, delta);
        break;
      default:
        break;
    }
  }

  void _moveEdge(Offset corner1, Offset corner2, Offset delta) {
    final edgeVector = corner2 - corner1;
    final edgeLength = edgeVector.distance;
    if (edgeLength == 0) return;

    final edgeDirection = edgeVector / edgeLength;
    final perpDirection = Offset(-edgeDirection.dy, edgeDirection.dx);

    final projectedDelta =
        (delta.dx * perpDirection.dx + delta.dy * perpDirection.dy);
    final moveVector = perpDirection * projectedDelta;

    switch (activeCorner) {
      case BoundingBoxCorner.topEdge:
        topLeft += moveVector;
        topRight += moveVector;
        _checkEdgeFlip(BoundingBoxCorner.topEdge, BoundingBoxCorner.bottomEdge);
        break;
      case BoundingBoxCorner.bottomEdge:
        bottomLeft += moveVector;
        bottomRight += moveVector;
        _checkEdgeFlip(BoundingBoxCorner.bottomEdge, BoundingBoxCorner.topEdge);
        break;
      case BoundingBoxCorner.leftEdge:
        topLeft += moveVector;
        bottomLeft += moveVector;
        _checkEdgeFlip(BoundingBoxCorner.leftEdge, BoundingBoxCorner.rightEdge);
        break;
      case BoundingBoxCorner.rightEdge:
        topRight += moveVector;
        bottomRight += moveVector;
        _checkEdgeFlip(BoundingBoxCorner.rightEdge, BoundingBoxCorner.leftEdge);
        break;
      default:
        break;
    }
  }

  void _checkEdgeFlip(
      BoundingBoxCorner currentEdge, BoundingBoxCorner oppositeEdge) {
    final topLeftToTopRight = topRight - topLeft;
    final topLeftToBottomLeft = bottomLeft - topLeft;

    final crossProduct = topLeftToTopRight.dx * topLeftToBottomLeft.dy -
        topLeftToTopRight.dy * topLeftToBottomLeft.dx;

    if (crossProduct < 0) {
      _swapCorners();
      activeCorner = oppositeEdge;
    }
  }

  void _swapCorners() {
    final center = this.center;

    final corners = [
      {'pos': topLeft, 'name': 'topLeft'},
      {'pos': topRight, 'name': 'topRight'},
      {'pos': bottomLeft, 'name': 'bottomLeft'},
      {'pos': bottomRight, 'name': 'bottomRight'},
    ];

    corners.sort((a, b) {
      final angleA = ((a['pos'] as Offset) - center).direction;
      final angleB = ((b['pos'] as Offset) - center).direction;
      return angleA.compareTo(angleB);
    });

    final sortedPositions = corners.map((c) => c['pos'] as Offset).toList();

    double minAngle = double.infinity;
    int topLeftIndex = 0;

    for (int i = 0; i < 4; i++) {
      final angle = (sortedPositions[i] - center).direction;
      final normalizedAngle = angle < 0 ? angle + 2 * math.pi : angle;
      final targetAngle = math.pi * 5 / 4;
      final angleDiff = (normalizedAngle - targetAngle).abs();
      final altAngleDiff = (2 * math.pi - angleDiff).abs();
      final minDiff = math.min(angleDiff, altAngleDiff);

      if (minDiff < minAngle) {
        minAngle = minDiff;
        topLeftIndex = i;
      }
    }

    topLeft = sortedPositions[topLeftIndex];
    topRight = sortedPositions[(topLeftIndex + 1) % 4];
    bottomRight = sortedPositions[(topLeftIndex + 2) % 4];
    bottomLeft = sortedPositions[(topLeftIndex + 3) % 4];
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

  Path getStarPath(int numberOfPoints, {double boxPadding = 0.0}) {
    final double effectiveWidth = math.max(0.0, width - boxPadding);
    final double effectiveHeight = math.max(0.0, height - boxPadding);
    return ShapePathUtils.generateStarPath(
      radiusX: effectiveWidth / 2,
      radiusY: effectiveHeight / 2,
      angle: angle,
      center: center,
      numberOfPoints: numberOfPoints,
    );
  }

  Path getHeartPath() {
    return ShapePathUtils.generateHeartPath(
      width: width,
      height: height,
      angle: angle,
      center: center,
    );
  }
}
