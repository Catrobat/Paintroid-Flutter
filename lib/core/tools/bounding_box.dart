import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/enums/bounding_box_resize_action.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';

class BoundingBox {
  Offset center;
  double width;
  double height;
  double angle;

  BoundingBoxAction currentAction = BoundingBoxAction.none;
  BoundingBoxResizeAction currentBoundingBoxResizeAction =
      BoundingBoxResizeAction.none;
  Offset? lastDragGlobalPosition;
  Offset? dragStartLocalPosition;
  int activeRotationArcIndex = -1;

  static const double minimalBoxSize = 48.0;
  static const double handleMargin = 28.0;
  static const double cornerHandleSize = 22.0;
  static const double rotationAreaOffset = 10.0;

  late Paint boxPaint;
  late Paint handlePaint;
  late Paint rotationHandlePaint;

  BoundingBox({
    required this.center,
    required this.width,
    required this.height,
    this.angle = 0.0,
  }) {
    width = math.max(width, minimalBoxSize);
    height = math.max(height, minimalBoxSize);

    boxPaint = GraphicFactory.boundingBoxTransparentPaint;
    handlePaint = GraphicFactory.boundingBoxHandlePaint;
    rotationHandlePaint = GraphicFactory.boundingBoxRotationHandlePaint;
  }

  factory BoundingBox.fromRect(Rect rect, {double angle = 0.0}) {
    return BoundingBox(
      center: rect.center,
      width: rect.width,
      height: rect.height,
      angle: angle,
    );
  }

  factory BoundingBox.fromCenter({
    required Offset center,
    required double width,
    required double height,
    double angle = 0.0,
  }) {
    return BoundingBox(
      center: center,
      width: width,
      height: height,
      angle: angle,
    );
  }

  Rect get rect =>
      Rect.fromCenter(center: center, width: width, height: height);

  List<Offset> getCorners() {
    final double halfWidth = width / 2;
    final double halfHeight = height / 2;
    final List<Offset> localCorners = [
      Offset(-halfWidth, -halfHeight),
      Offset(halfWidth, -halfHeight),
      Offset(halfWidth, halfHeight),
      Offset(-halfWidth, halfHeight),
    ];
    return localCorners.map((lc) => lc.localToGlobal(center, angle)).toList();
  }

  bool isAspectRatioLocked = false;

  void determineAction(Offset globalPoint) {
    lastDragGlobalPosition = globalPoint;
    final Offset localPoint = globalPoint.globalToLocal(center, angle);
    dragStartLocalPosition = localPoint;

    currentAction = BoundingBoxAction.none;
    currentBoundingBoxResizeAction = BoundingBoxResizeAction.none;
    activeRotationArcIndex = -1;

    final double halfWidth = width / 2;
    final double halfHeight = height / 2;

    bool onTopLeftCorner =
        (localPoint - Offset(-halfWidth, -halfHeight)).distance <
            cornerHandleSize * 1.3;
    bool onTopRightCorner =
        (localPoint - Offset(halfWidth, -halfHeight)).distance <
            cornerHandleSize * 1.3;
    bool onBottomLeftCorner =
        (localPoint - Offset(-halfWidth, halfHeight)).distance <
            cornerHandleSize * 1.3;
    bool onBottomRightCorner =
        (localPoint - Offset(halfWidth, halfHeight)).distance <
            cornerHandleSize * 1.3;
    if (onTopLeftCorner ||
        onTopRightCorner ||
        onBottomLeftCorner ||
        onBottomRightCorner) {
      currentAction = BoundingBoxAction.resize;
      isAspectRatioLocked = true;
      if (onTopLeftCorner) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.topLeft;
      } else if (onTopRightCorner) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.topRight;
      } else if (onBottomLeftCorner) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.bottomLeft;
      } else if (onBottomRightCorner) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.bottomRight;
      }
      return;
    }

    bool onTopEdge = localPoint.dy > -halfHeight - handleMargin &&
        localPoint.dy < -halfHeight + handleMargin &&
        localPoint.dx.abs() < halfWidth - handleMargin / 2;
    bool onBottomEdge = localPoint.dy > halfHeight - handleMargin &&
        localPoint.dy < halfHeight + handleMargin &&
        localPoint.dx.abs() < halfWidth - handleMargin / 2;
    bool onLeftEdge = localPoint.dx > -halfWidth - handleMargin &&
        localPoint.dx < -halfWidth + handleMargin &&
        localPoint.dy.abs() < halfHeight - handleMargin / 2;
    bool onRightEdge = localPoint.dx > halfWidth - handleMargin &&
        localPoint.dx < halfWidth + handleMargin &&
        localPoint.dy.abs() < halfHeight - handleMargin / 2;
    if (onTopEdge || onBottomEdge || onLeftEdge || onRightEdge) {
      currentAction = BoundingBoxAction.resize;
      isAspectRatioLocked = false;
      if (onTopEdge) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.top;
      } else if (onBottomEdge) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.bottom;
      } else if (onLeftEdge) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.left;
      } else if (onRightEdge) {
        currentBoundingBoxResizeAction = BoundingBoxResizeAction.right;
      }
      return;
    }

    const double arcRadiusForDrawing = 120;
    const double arcThicknessForDrawing = 60;
    const double arcSweepForDrawing = math.pi / 2;
    final List<Offset> localBoxCorners = [
      Offset(-halfWidth, -halfHeight),
      Offset(halfWidth, -halfHeight),
      Offset(halfWidth, halfHeight),
      Offset(-halfWidth, halfHeight),
    ];
    final List<double> arcRotationAngles = [
      -math.pi,
      -math.pi / 2,
      0.0,
      math.pi / 2,
    ];
    for (int i = 0; i < localBoxCorners.length; i++) {
      final Offset arcHandleCenter = localBoxCorners[i] +
          (localBoxCorners[i].normalized() * rotationAreaOffset);
      if (_isPointOnArc(
        localPoint,
        arcHandleCenter,
        arcRotationAngles[i],
        arcSweepForDrawing,
        arcRadiusForDrawing,
        arcThicknessForDrawing,
        true,
      )) {
        currentAction = BoundingBoxAction.rotate;
        activeRotationArcIndex = i;
        return;
      }
    }

    final List<Offset> cornersForOldRotationHandles = [
      Offset(-halfWidth, -halfHeight),
      Offset(halfWidth, -halfHeight),
      Offset(halfWidth, halfHeight),
      Offset(-halfWidth, halfHeight)
    ];
    for (int i = 0; i < cornersForOldRotationHandles.length; i++) {
      final Offset rotationHandleCenterLocal = cornersForOldRotationHandles[i] +
          (cornersForOldRotationHandles[i].normalized() * rotationAreaOffset);
      if ((globalPoint - rotationHandleCenterLocal.localToGlobal(center, angle))
              .distanceSquared <
          handleMargin * handleMargin) {
        currentAction = BoundingBoxAction.rotate;
        activeRotationArcIndex = i;
        return;
      }
    }
    currentAction = BoundingBoxAction.move;
  }

  void updateDrag(Offset globalPoint) {
    if (lastDragGlobalPosition == null ||
        currentAction == BoundingBoxAction.none) {
      return;
    }

    final Offset globalDelta = globalPoint - lastDragGlobalPosition!;
    final Offset prevGlobalDragPosition = lastDragGlobalPosition!;
    lastDragGlobalPosition = globalPoint;

    switch (currentAction) {
      case BoundingBoxAction.move:
        center += globalDelta;
        break;
      case BoundingBoxAction.rotate:
        final Offset vectorOld = prevGlobalDragPosition - center;
        final Offset vectorNew = globalPoint - center;
        angle += vectorNew.direction - vectorOld.direction;
        angle = (angle + math.pi) % (2 * math.pi) - math.pi;
        break;
      case BoundingBoxAction.resize:
        _performResize(globalPoint, prevGlobalDragPosition);
        break;
      case BoundingBoxAction.none:
        break;
    }
  }

  void _performResize(Offset currentGlobalDragPos, Offset prevGlobalDragPos) {
    final Offset localCurrentDragPos =
        currentGlobalDragPos.globalToLocal(center, angle);
    final Offset localPrevDragPos =
        prevGlobalDragPos.globalToLocal(center, angle);
    final Offset localDelta = localCurrentDragPos - localPrevDragPos;

    double dWidth = 0;
    double dHeight = 0;
    Offset localFixedPoint;
    bool keepAspect = isAspectRatioLocked;
    double aspectRatio = (height == 0) ? 1 : width / height;

    switch (currentBoundingBoxResizeAction) {
      case BoundingBoxResizeAction.left:
        dWidth = -localDelta.dx;
        localFixedPoint = Offset(width / 2, dragStartLocalPosition?.dy ?? 0);
        break;
      case BoundingBoxResizeAction.right:
        dWidth = localDelta.dx;
        localFixedPoint = Offset(-width / 2, dragStartLocalPosition?.dy ?? 0);
        break;
      case BoundingBoxResizeAction.top:
        dHeight = -localDelta.dy;
        localFixedPoint = Offset(dragStartLocalPosition?.dx ?? 0, height / 2);
        break;
      case BoundingBoxResizeAction.bottom:
        dHeight = localDelta.dy;
        localFixedPoint = Offset(dragStartLocalPosition?.dx ?? 0, -height / 2);
        break;
      case BoundingBoxResizeAction.topLeft:
        keepAspect = true;
        dWidth = -localDelta.dx;
        dHeight = -localDelta.dy;
        localFixedPoint = Offset(width / 2, height / 2);
        break;
      case BoundingBoxResizeAction.topRight:
        keepAspect = true;
        dWidth = localDelta.dx;
        dHeight = -localDelta.dy;
        localFixedPoint = Offset(-width / 2, height / 2);
        break;
      case BoundingBoxResizeAction.bottomLeft:
        keepAspect = true;
        dWidth = -localDelta.dx;
        dHeight = localDelta.dy;
        localFixedPoint = Offset(width / 2, -height / 2);
        break;
      case BoundingBoxResizeAction.bottomRight:
        keepAspect = true;
        dWidth = localDelta.dx;
        dHeight = localDelta.dy;
        localFixedPoint = Offset(-width / 2, -height / 2);
        break;
      default:
        return;
    }

    final Offset globalFixedPoint =
        localFixedPoint.localToGlobal(center, angle);

    double newWidth = width + dWidth;
    double newHeight = height + dHeight;

    if (keepAspect) {
      if (dWidth.abs() > dHeight.abs()) {
        newHeight = (newWidth / aspectRatio).abs() * newHeight.sign;
      } else {
        newWidth = (newHeight * aspectRatio).abs() * newWidth.sign;
      }
    }

    if (keepAspect) {
      if (newWidth.sign != (width + dWidth).sign &&
          (width + dWidth).sign != 0) {
        newWidth = minimalBoxSize * (width + dWidth).sign;
      }
      if (newHeight.sign != (height + dHeight).sign &&
          (height + dHeight).sign != 0) {
        newHeight = minimalBoxSize * (height + dHeight).sign;
      }

      if ((width + dWidth).abs() > (height + dHeight).abs()) {
        newHeight = (newWidth.abs() / aspectRatio) * newHeight.sign;
      } else {
        newWidth = (newHeight.abs() * aspectRatio) * newWidth.sign;
      }
    }

    if (width <= minimalBoxSize && newWidth < width) {
      newWidth = width;
    }
    if (height <= minimalBoxSize && newHeight < height) {
      newHeight = height;
    }

    width = math.max(newWidth.abs(), minimalBoxSize) * newWidth.sign;
    height = math.max(newHeight.abs(), minimalBoxSize) * newHeight.sign;

    if (width.abs() < minimalBoxSize) width = minimalBoxSize * width.sign;
    if (height.abs() < minimalBoxSize) height = minimalBoxSize * height.sign;

    Offset newLocalFixedPoint;
    double prevWidth = width - dWidth;
    double prevHeight = height - dHeight;

    switch (currentBoundingBoxResizeAction) {
      case BoundingBoxResizeAction.left:
        newLocalFixedPoint = Offset(width / 2,
            localFixedPoint.dy * (height / (prevHeight != 0 ? prevHeight : 1)));
        break;
      case BoundingBoxResizeAction.right:
        newLocalFixedPoint = Offset(-width / 2,
            localFixedPoint.dy * (height / (prevHeight != 0 ? prevHeight : 1)));
        break;
      case BoundingBoxResizeAction.top:
        newLocalFixedPoint = Offset(
            localFixedPoint.dx * (width / (prevWidth != 0 ? prevWidth : 1)),
            height / 2);
        break;
      case BoundingBoxResizeAction.bottom:
        newLocalFixedPoint = Offset(
            localFixedPoint.dx * (width / (prevWidth != 0 ? prevWidth : 1)),
            -height / 2);
        break;
      case BoundingBoxResizeAction.topLeft:
        newLocalFixedPoint = Offset(width / 2, height / 2);
        break;
      case BoundingBoxResizeAction.topRight:
        newLocalFixedPoint = Offset(-width / 2, height / 2);
        break;
      case BoundingBoxResizeAction.bottomLeft:
        newLocalFixedPoint = Offset(width / 2, -height / 2);
        break;
      case BoundingBoxResizeAction.bottomRight:
        newLocalFixedPoint = Offset(-width / 2, -height / 2);
        break;
      default:
        return;
    }
    center = globalFixedPoint - newLocalFixedPoint.localToGlobalRelative(angle);
  }

  void endDrag() {
    lastDragGlobalPosition = null;
    dragStartLocalPosition = null;
  }

  void drawGuides(Canvas canvas) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final Rect localRect =
        Rect.fromCenter(center: Offset.zero, width: width, height: height);

    final Paint borderPaint = GraphicFactory.boundingBoxRectPaint;
    canvas.drawRect(localRect, borderPaint);

    final double halfW = width / 2;
    final double halfH = height / 2;

    final List<Offset> localBoxCorners = [
      Offset(-halfW, -halfH),
      Offset(halfW, -halfH),
      Offset(halfW, halfH),
      Offset(-halfW, halfH),
    ];

    final double handleLength = (math.min(width, height) * 0.2);

    for (int i = 0; i < localBoxCorners.length; i++) {
      final Offset corner = localBoxCorners[i];
      Offset horizontal, vertical;

      switch (i) {
        case 0:
          horizontal = Offset(handleLength, 0);
          vertical = Offset(0, handleLength);
          break;
        case 1:
          horizontal = Offset(-handleLength, 0);
          vertical = Offset(0, handleLength);
          break;
        case 2:
          horizontal = Offset(-handleLength, 0);
          vertical = Offset(0, -handleLength);
          break;
        case 3:
          horizontal = Offset(handleLength, 0);
          vertical = Offset(0, -handleLength);
          break;
        default:
          horizontal = vertical = Offset.zero;
      }

      final path = Path()
        ..moveTo(corner.dx, corner.dy)
        ..lineTo(corner.dx + horizontal.dx, corner.dy + horizontal.dy)
        ..lineTo(corner.dx, corner.dy)
        ..lineTo(corner.dx + vertical.dx, corner.dy + vertical.dy);

      canvas.drawPath(path, handlePaint);
    }

    final double edgeHandleLength = (math.min(width, height) * 0.2);

    canvas.drawLine(Offset(-edgeHandleLength / 2, -halfH),
        Offset(edgeHandleLength / 2, -halfH), handlePaint);
    canvas.drawLine(Offset(-edgeHandleLength / 2, halfH),
        Offset(edgeHandleLength / 2, halfH), handlePaint);
    canvas.drawLine(Offset(-halfW, -edgeHandleLength / 2),
        Offset(-halfW, edgeHandleLength / 2), handlePaint);
    canvas.drawLine(Offset(halfW, -edgeHandleLength / 2),
        Offset(halfW, edgeHandleLength / 2), handlePaint);

    final List<double> arcRotationAngles = [
      -math.pi,
      -math.pi / 2,
      0.0,
      math.pi / 2,
    ];

    for (int i = 0; i < localBoxCorners.length; i++) {
      final Offset localCornerBase = localBoxCorners[i];
      final Offset arcHandleCenter =
          localCornerBase + (localCornerBase.normalized() * rotationAreaOffset);
      final double currentArcRotationAngle = arcRotationAngles[i];

      bool highlightThisArc = false;
      if (currentAction == BoundingBoxAction.rotate &&
          i == activeRotationArcIndex) {
        highlightThisArc = true;
      }
      _drawCurvedArrow(canvas, arcHandleCenter, currentArcRotationAngle,
          highlight: highlightThisArc);
    }

    canvas.restore();
  }

  void _drawCurvedArrow(Canvas canvas, Offset center, double rotationAngle,
      {bool highlight = false}) {
    const double radius = 120;
    const double sweepAngle = math.pi / 2;
    const double arrowStrokeWidth = 40;

    final double arcInset = arrowStrokeWidth / 2;
    final Rect insetArcRect =
        Rect.fromCircle(center: Offset.zero, radius: radius - arcInset / 2);
    final Path arcPath = Path()..addArc(insetArcRect, 0, sweepAngle);

    void drawArrowHead(
        Canvas canvas, Offset tip, double angle, Paint arrowPaint) {
      const double size = 20;
      const double openAngle = 1;

      final Offset leftDir = Offset(
        math.cos(angle - openAngle),
        math.sin(angle - openAngle),
      );
      final Offset rightDir = Offset(
        math.cos(angle + openAngle),
        math.sin(angle + openAngle),
      );

      final Path path = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(
          tip.dx + leftDir.dx * size,
          tip.dy + leftDir.dy * size,
        )
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(
          tip.dx + rightDir.dx * size,
          tip.dy + rightDir.dy * size,
        );
      canvas.drawPath(path, arrowPaint);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    canvas.drawPath(arcPath, rotationHandlePaint);

    final double startAngle = 0;
    final double endAngle = sweepAngle;
    final Offset arcStart = Offset((radius - arcInset / 2) * math.cos(endAngle),
        (radius - arcInset / 2) * math.sin(endAngle));
    final Offset arcEnd = Offset((radius - arcInset / 2) * math.cos(startAngle),
        (radius - arcInset / 2) * math.sin(startAngle));
    drawArrowHead(canvas, arcStart, startAngle, rotationHandlePaint);
    drawArrowHead(canvas, arcEnd, endAngle, rotationHandlePaint);

    canvas.restore();
  }

  bool _isPointOnArc(
      Offset point,
      Offset arcCenterLocalToBox,
      double arcStartAngleInBox,
      double arcSweep,
      double arcRadius,
      double arcThickness,
      [bool isHighlightCheck = false]) {
    Offset pointRelativeToArcCenter;
    double theta;

    if (isHighlightCheck) {
      final Offset pointRelativeToBoxCenter = point;
      Offset p = pointRelativeToBoxCenter - arcCenterLocalToBox;
      double cosA = math.cos(-arcStartAngleInBox);
      double sinA = math.sin(-arcStartAngleInBox);
      pointRelativeToArcCenter =
          Offset(p.dx * cosA - p.dy * sinA, p.dx * sinA + p.dy * cosA);
      theta = pointRelativeToArcCenter.direction;
    } else {
      final Offset globalPoint = point;
      final Offset arcCenterGlobal = arcCenterLocalToBox;
      final double globalArcStartAngle = arcStartAngleInBox;

      pointRelativeToArcCenter = globalPoint - arcCenterGlobal;
      theta = pointRelativeToArcCenter.direction;
      theta = (theta - globalArcStartAngle + 2 * math.pi) % (2 * math.pi);
    }

    final double r = pointRelativeToArcCenter.distance;
    return r >= arcRadius - arcThickness / 2 &&
        r <= arcRadius + arcThickness / 2 &&
        theta >= 0 &&
        theta <= arcSweep;
  }
}
