import 'dart:math';
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
    edgeSensitivity = anchorRadius / 2.5;
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
      double distToTopEdge = _distanceToSegment(point, topLeft, topRight);
      double distToBottomEdge =
          _distanceToSegment(point, bottomLeft, bottomRight);
      double distToLeftEdge = _distanceToSegment(point, topLeft, bottomLeft);
      double distToRightEdge = _distanceToSegment(point, topRight, bottomRight);

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

  double _distanceToSegment(Offset p, Offset v, Offset w) {
    final double l2 = (v - w).distanceSquared;
    if (l2 == 0.0) return (p - v).distance;
    double t =
        ((p.dx - v.dx) * (w.dx - v.dx) + (p.dy - v.dy) * (w.dy - v.dy)) / l2;
    t = max(0, min(1, t));
    final Offset projection = v + (w - v) * t;
    return (p - projection).distance;
  }

  double _getActiveCornerDistanceToCenter(Offset centerPoint) {
    switch (activeCorner) {
      case BoundingBoxCorner.topLeft:
      case BoundingBoxCorner.topLeftRotationArc:
        return topLeft.distanceTo(centerPoint);
      case BoundingBoxCorner.topRight:
      case BoundingBoxCorner.topRightRotationArc:
        return topRight.distanceTo(centerPoint);
      case BoundingBoxCorner.bottomLeft:
      case BoundingBoxCorner.bottomLeftRotationArc:
        return bottomLeft.distanceTo(centerPoint);
      case BoundingBoxCorner.bottomRight:
      case BoundingBoxCorner.bottomRightRotationArc:
        return bottomRight.distanceTo(centerPoint);
      default:
        return 1.0;
    }
  }

  void scale(Offset point) {
    final Offset currentCenter = center;
    final double initialDistanceOfActiveCorner =
        _getActiveCornerDistanceToCenter(currentCenter);
    final double targetDistanceOfActiveCorner =
        (point - currentCenter).distance;

    final double scaleFactor = (initialDistanceOfActiveCorner == 0 ||
            targetDistanceOfActiveCorner == 0)
        ? 1.0
        : targetDistanceOfActiveCorner / initialDistanceOfActiveCorner;

    final Offset oldTopLeft = topLeft;
    final double oldTopLeftAngle = (oldTopLeft - currentCenter).direction;
    final double newTopLeftDistance =
        (oldTopLeft - currentCenter).distance * scaleFactor;
    topLeft = currentCenter.move(newTopLeftDistance, oldTopLeftAngle);

    final Offset oldTopRight = topRight;
    final double oldTopRightAngle = (oldTopRight - currentCenter).direction;
    final double newTopRightDistance =
        (oldTopRight - currentCenter).distance * scaleFactor;
    topRight = currentCenter.move(newTopRightDistance, oldTopRightAngle);

    final Offset oldBottomLeft = bottomLeft;
    final double oldBottomLeftAngle = (oldBottomLeft - currentCenter).direction;
    final double newBottomLeftDistance =
        (oldBottomLeft - currentCenter).distance * scaleFactor;
    bottomLeft = currentCenter.move(newBottomLeftDistance, oldBottomLeftAngle);

    final Offset oldBottomRight = bottomRight;
    final double oldBottomRightAngle =
        (oldBottomRight - currentCenter).direction;
    final double newBottomRightDistance =
        (oldBottomRight - currentCenter).distance * scaleFactor;
    bottomRight =
        currentCenter.move(newBottomRightDistance, oldBottomRightAngle);
  }

  void drawBoundingBox(Canvas canvas) {
    final double bbWidth =
        (topRight - topLeft).distance;
    final double bbHeight =
        (bottomLeft - topLeft).distance;
    if (bbWidth <= 0 || bbHeight <= 0) {
      return;
    }
    final double rotationAngle =
        (topRight - topLeft).direction;

    canvas.save();
    canvas.translate(topLeft.dx, topLeft.dy);
    canvas.rotate(rotationAngle);
    final cornerRadius = bbWidth / 10;
    final double effectiveCornerRadius = cornerRadius > 0 ? cornerRadius : 0.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, bbWidth, bbHeight),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(rrect, GraphicFactory.guideRectanglePaint);
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
          Offset(0, effectiveCornerRadius + arcExtensionLength), // Extend down
          GraphicFactory.guideCornerArcEdgePaint);
      canvas.drawArc(
        Rect.fromCircle(
            center:
            Offset(effectiveCornerRadius - 30, effectiveCornerRadius - 30),
            radius: effectiveCornerRadius * 2.5),
        math.pi,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
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
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(bbWidth - effectiveCornerRadius + 30,
                effectiveCornerRadius - 30),
            radius: effectiveCornerRadius * 2.5),
        -math.pi / 2,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
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
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(bbWidth - effectiveCornerRadius + 30,
                bbHeight - effectiveCornerRadius + 30),
            radius: effectiveCornerRadius * 2.5),
        0,
        math.pi / 2,
        false,
        GraphicFactory.guideCornerArcEdgePaint,
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
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(effectiveCornerRadius - 30,
              bbHeight - effectiveCornerRadius + 30),
          radius: effectiveCornerRadius * 2.5),
      math.pi / 2,
      math.pi / 2,
      false,
      GraphicFactory.guideCornerArcEdgePaint,
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
    final originalTopLeft = topLeft;
    final originalTopRight = topRight;
    final originalBottomLeft = bottomLeft;
    final originalBottomRight = bottomRight;

    switch (activeCorner) {
      case BoundingBoxCorner.topEdge:
        final stretchedTop = _calculateStretchedTopEdge(
            point,
            originalTopLeft,
            originalTopRight,
            originalBottomLeft,
            originalBottomRight,
            lastPoint);
        topLeft = stretchedTop.newTopLeft;
        topRight = stretchedTop.newTopRight;
        break;
      case BoundingBoxCorner.bottomEdge:
        final stretchedBottom = _calculateStretchedBottomEdge(
            point,
            originalTopLeft,
            originalTopRight,
            originalBottomLeft,
            originalBottomRight,
            lastPoint);
        bottomLeft = stretchedBottom.newBottomLeft;
        bottomRight = stretchedBottom.newBottomRight;
        break;
      case BoundingBoxCorner.leftEdge:
        final stretchedLeft = _calculateStretchedLeftEdge(
            point,
            originalTopLeft,
            originalTopRight,
            originalBottomLeft,
            originalBottomRight,
            lastPoint);
        topLeft = stretchedLeft.newTopLeft;
        bottomLeft = stretchedLeft.newBottomLeft;
        break;
      case BoundingBoxCorner.rightEdge:
        final stretchedRight = _calculateStretchedRightEdge(
            point,
            originalTopLeft,
            originalTopRight,
            originalBottomLeft,
            originalBottomRight,
            lastPoint);
        topRight = stretchedRight.newTopRight;
        bottomRight = stretchedRight.newBottomRight;
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

  ({Offset newTopLeft, Offset newTopRight}) _calculateStretchedTopEdge(
    Offset currentPoint,
    Offset originalTopLeft,
    Offset originalTopRight,
    Offset originalBottomLeft,
    Offset originalBottomRight,
    Offset lastPoint,
  ) {
    final dragVector = currentPoint - lastPoint;
    final edgeVector = originalTopRight - originalTopLeft;
    final perpendicularToEdge =
        Offset(edgeVector.dy, -edgeVector.dx).normalized();

    final dragDistance = dragVector.dx * perpendicularToEdge.dx +
        dragVector.dy * perpendicularToEdge.dy;

    final newTopLeft = originalTopLeft + perpendicularToEdge * dragDistance;
    final newTopRight = originalTopRight + perpendicularToEdge * dragDistance;

    return (newTopLeft: newTopLeft, newTopRight: newTopRight);
  }

  ({Offset newBottomLeft, Offset newBottomRight}) _calculateStretchedBottomEdge(
    Offset currentPoint,
    Offset originalTopLeft,
    Offset originalTopRight,
    Offset originalBottomLeft,
    Offset originalBottomRight,
    Offset lastPoint,
  ) {
    final dragVector = currentPoint - lastPoint;
    final edgeVector = originalBottomRight - originalBottomLeft;
    final perpendicularToEdge =
        Offset(edgeVector.dy, -edgeVector.dx).normalized();
    final dragDistance = dragVector.dx * perpendicularToEdge.dx +
        dragVector.dy * perpendicularToEdge.dy;

    final newBottomLeft =
        originalBottomLeft + perpendicularToEdge * dragDistance;
    final newBottomRight =
        originalBottomRight + perpendicularToEdge * dragDistance;

    return (newBottomLeft: newBottomLeft, newBottomRight: newBottomRight);
  }

  ({Offset newTopLeft, Offset newBottomLeft}) _calculateStretchedLeftEdge(
    Offset currentPoint,
    Offset originalTopLeft,
    Offset originalTopRight,
    Offset originalBottomLeft,
    Offset originalBottomRight,
    Offset lastPoint,
  ) {
    final dragVector = currentPoint - lastPoint;
    final edgeVector = originalBottomLeft - originalTopLeft;
    final perpendicularToEdge =
        Offset(edgeVector.dy, -edgeVector.dx).normalized();
    final dragDistance = dragVector.dx * perpendicularToEdge.dx +
        dragVector.dy * perpendicularToEdge.dy;

    final newTopLeft = originalTopLeft + perpendicularToEdge * dragDistance;
    final newBottomLeft =
        originalBottomLeft + perpendicularToEdge * dragDistance;

    return (newTopLeft: newTopLeft, newBottomLeft: newBottomLeft);
  }

  ({Offset newTopRight, Offset newBottomRight}) _calculateStretchedRightEdge(
    Offset currentPoint,
    Offset originalTopLeft,
    Offset originalTopRight,
    Offset originalBottomLeft,
    Offset originalBottomRight,
    Offset lastPoint,
  ) {
    final dragVector = currentPoint - lastPoint;
    final edgeVector = originalBottomRight - originalTopRight;
    final perpendicularToEdge =
        Offset(edgeVector.dy, -edgeVector.dx).normalized();
    final dragDistance = dragVector.dx * perpendicularToEdge.dx +
        dragVector.dy * perpendicularToEdge.dy;

    final newTopRight = originalTopRight + perpendicularToEdge * dragDistance;
    final newBottomRight =
        originalBottomRight + perpendicularToEdge * dragDistance;

    return (newTopRight: newTopRight, newBottomRight: newBottomRight);
  }

  Path getPath({double padding = 0}) => Path()
    ..moveToOffset(getPaddedTopLeft(padding: padding))
    ..lineToOffset(getPaddedTopRight(padding: padding))
    ..lineToOffset(getPaddedBottomRight(padding: padding))
    ..lineToOffset(getPaddedBottomLeft(padding: padding))
    ..close();
}
