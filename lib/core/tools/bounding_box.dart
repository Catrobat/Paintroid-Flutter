import 'dart:math' as math;
import 'dart:ui';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';
import 'package:paintroid/core/extensions/path_extension.dart';

class BoundingBox {
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
  Offset lastPoint = Offset.zero;

  final anchorRadius = 40.0;
  final double rotationArcOffset = 60.0;
  final padding = GraphicFactory.guidePaint.strokeWidth * 4;
  BoundingBoxCorner activeCorner = BoundingBoxCorner.none;
  late final double edgeSensitivity;

  BoundingBox(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight) {
    edgeSensitivity = anchorRadius / 2;
  }

  double get rotationArcHandleRadius =>
      ((topRight - topLeft).distance / 2.5).clamp(padding, anchorRadius * 1.5);

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
    } else if (point.isWithinRadius(
        topRightRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.topRightRotationArc;
    } else if (point.isWithinRadius(
        bottomLeftRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.bottomLeftRotationArc;
    } else if (point.isWithinRadius(
        bottomRightRotationArcCenter, rotationArcHandleRadius)) {
      activeCorner = BoundingBoxCorner.bottomRightRotationArc;
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

  void resetActiveCorner() => activeCorner = BoundingBoxCorner.none;

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
    switch (activeCorner) {
      case BoundingBoxCorner.topEdge:
        double top = math.min(point.dy, bottomLeft.dy);
        topLeft = Offset(topLeft.dx, top);
        topRight = Offset(topRight.dx, top);
        if (point.dy > bottomLeft.dy) activeCorner = BoundingBoxCorner.bottomEdge;
        break;
      case BoundingBoxCorner.bottomEdge:
        double bottom = math.max(point.dy, topLeft.dy);
        bottomLeft = Offset(bottomLeft.dx, bottom);
        bottomRight = Offset(bottomRight.dx, bottom);
        if (point.dy < topLeft.dy) activeCorner = BoundingBoxCorner.topEdge;
        break;
      case BoundingBoxCorner.leftEdge:
        double left = math.min(point.dx, topRight.dx);
        topLeft = Offset(left, topLeft.dy);
        bottomLeft = Offset(left, bottomLeft.dy);
        if (point.dx > topRight.dx) activeCorner = BoundingBoxCorner.rightEdge;
        break;
      case BoundingBoxCorner.rightEdge:
        double right = math.max(point.dx, topLeft.dx);
        topRight = Offset(right, topRight.dy);
        bottomRight = Offset(right, bottomRight.dy);
        if (point.dx < topLeft.dx) activeCorner = BoundingBoxCorner.leftEdge;
        break;
      default:
        break;
    }
  }

  void rotate(Offset point) {
    if (activeCornerDirection == 0 &&
        !(activeCorner == BoundingBoxCorner.topLeftRotationArc ||
            activeCorner == BoundingBoxCorner.topRightRotationArc ||
            activeCorner == BoundingBoxCorner.bottomLeftRotationArc ||
            activeCorner == BoundingBoxCorner.bottomRightRotationArc)) {
      return;
    }

    double referenceAngle = 0;
    switch (activeCorner) {
      case BoundingBoxCorner.topLeftRotationArc:
        referenceAngle = (topLeft - center).direction;
        break;
      case BoundingBoxCorner.topRightRotationArc:
        referenceAngle = (topRight - center).direction;
        break;
      case BoundingBoxCorner.bottomLeftRotationArc:
        referenceAngle = (bottomLeft - center).direction;
        break;
      case BoundingBoxCorner.bottomRightRotationArc:
        referenceAngle = (bottomRight - center).direction;
        break;
      default:
        referenceAngle = activeCornerDirection;
    }
    if (referenceAngle == 0 && activeCornerDirection == 0) {
      return;
    }

    final direction = (point - center).direction - referenceAngle;

    final currentTopLeft = topLeft;
    final currentTopRight = topRight;
    final currentBottomLeft = bottomLeft;
    final currentBottomRight = bottomRight;

    final newTopLeft = center.move(currentTopLeft.distanceTo(center),
        (currentTopLeft - center).direction + direction);
    final newTopRight = center.move(currentTopRight.distanceTo(center),
        (currentTopRight - center).direction + direction);
    final newBottomLeft = center.move(currentBottomLeft.distanceTo(center),
        (currentBottomLeft - center).direction + direction);
    final newBottomRight = center.move(currentBottomRight.distanceTo(center),
        (currentBottomRight - center).direction + direction);

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
}
