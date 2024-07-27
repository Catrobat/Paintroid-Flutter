import 'dart:ui';
import 'package:paintroid/core/tools/tool.dart';

enum Corner {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class ShapesTool extends Tool {
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
  bool isRotating;
  bool movingBoundingBox = false;
  Corner currentMovingCorner = Corner.none;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
    this.topLeft = Offset.zero,
    this.topRight = Offset.zero,
    this.bottomLeft = Offset.zero,
    this.bottomRight = Offset.zero,
    this.isRotating = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    if (isRotating) {
      _setRotationFlags(point);
    } else {
      _setTranslationAndScalingFlags(point);
    }
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (isRotating) {
      _rotateBoundingBox(point);
    } else {
      _updateBoundingBox(point);
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    _resetFlags();
  }

  @override
  void onCancel() {
    _resetFlags();
  }

  @override
  void onCheckmark() {}

  @override
  void onPlus() {}

  @override
  void onRedo() {}

  @override
  void onUndo() {}

  void _setTranslationAndScalingFlags(Offset point) {
    const circleRadius = 30.0;

    if ((point - topLeft).distance < circleRadius) {
      currentMovingCorner = Corner.topLeft;
    } else if ((point - topRight).distance < circleRadius) {
      currentMovingCorner = Corner.topRight;
    } else if ((point - bottomLeft).distance < circleRadius) {
      currentMovingCorner = Corner.bottomLeft;
    } else if ((point - bottomRight).distance < circleRadius) {
      currentMovingCorner = Corner.bottomRight;
    } else {
      movingBoundingBox = true;
    }
    _updateBoundingBox(point);
  }

  void _setRotationFlags(Offset point) {
    const circleRadius = 30.0;

    if ((point - topLeft).distance < circleRadius) {
      currentMovingCorner = Corner.topLeft;
    } else if ((point - topRight).distance < circleRadius) {
      currentMovingCorner = Corner.topRight;
    } else if ((point - bottomLeft).distance < circleRadius) {
      currentMovingCorner = Corner.bottomLeft;
    } else if ((point - bottomRight).distance < circleRadius) {
      currentMovingCorner = Corner.bottomRight;
    }
  }

  void _updateBoundingBox(Offset point) {
    if (!isRotating) {
      switch (currentMovingCorner) {
        case Corner.topLeft:
          topLeft = point;
          _updateOtherCornersFromCorner(Corner.topLeft);
          break;
        case Corner.topRight:
          topRight = point;
          _updateOtherCornersFromCorner(Corner.topRight);
          break;
        case Corner.bottomLeft:
          bottomLeft = point;
          _updateOtherCornersFromCorner(Corner.bottomLeft);
          break;
        case Corner.bottomRight:
          bottomRight = point;
          _updateOtherCornersFromCorner(Corner.bottomRight);
          break;
        case Corner.none:
          if (movingBoundingBox) {
            final center = _calculateCenter();
            final dx = point.dx - center.dx;
            final dy = point.dy - center.dy;
            _translateBoundingBox(dx, dy);
          }
          break;
      }
    }
  }

  void _updateOtherCornersFromCorner(Corner corner) {
    final center = _calculateCenter();
    final diagonal = _getDiagonal(corner);
    final angle = _getAngle(corner);

    switch (corner) {
      case Corner.topLeft:
        topRight = center + Offset.fromDirection(angle - 1.5708, diagonal / 2);
        bottomLeft =
            center + Offset.fromDirection(angle + 1.5708, diagonal / 2);
        break;
      case Corner.topRight:
        topLeft = center + Offset.fromDirection(angle + 1.5708, diagonal / 2);
        bottomRight =
            center + Offset.fromDirection(angle - 1.5708, diagonal / 2);
        break;
      case Corner.bottomLeft:
        topLeft = center + Offset.fromDirection(angle - 1.5708, diagonal / 2);
        bottomRight =
            center + Offset.fromDirection(angle + 1.5708, diagonal / 2);
        break;
      case Corner.bottomRight:
        topRight = center + Offset.fromDirection(angle + 1.5708, diagonal / 2);
        bottomLeft =
            center + Offset.fromDirection(angle - 1.5708, diagonal / 2);
        break;
      case Corner.none:
        break;
    }
  }

  void _rotateBoundingBox(Offset point) {
    final center = _calculateCenter();
    final initialAngles = _getInitialAngles(center);
    final currentAngle = (point - center).direction;
    final initialAngle = _getInitialAngle();

    if (initialAngle == 0) return;

    final rotationAngle = currentAngle - initialAngle;

    topLeft = _rotatePoint(
        topLeft, initialAngles[Corner.topLeft]!, rotationAngle, center);
    topRight = _rotatePoint(
        topRight, initialAngles[Corner.topRight]!, rotationAngle, center);
    bottomLeft = _rotatePoint(
        bottomLeft, initialAngles[Corner.bottomLeft]!, rotationAngle, center);
    bottomRight = _rotatePoint(
        bottomRight, initialAngles[Corner.bottomRight]!, rotationAngle, center);
  }

  double _getInitialAngle() {
    if (currentMovingCorner != Corner.none) {
      return _getInitialAngles(_calculateCenter())[currentMovingCorner]!;
    }
    return 0;
  }

  void _resetFlags() {
    movingBoundingBox = false;
    currentMovingCorner = Corner.none;
  }

  Offset _calculateCenter() {
    return Offset(
      (topLeft.dx + topRight.dx + bottomLeft.dx + bottomRight.dx) / 4,
      (topLeft.dy + topRight.dy + bottomLeft.dy + bottomRight.dy) / 4,
    );
  }

  void _translateBoundingBox(double dx, double dy) {
    topLeft = Offset(topLeft.dx + dx, topLeft.dy + dy);
    topRight = Offset(topRight.dx + dx, topRight.dy + dy);
    bottomLeft = Offset(bottomLeft.dx + dx, bottomLeft.dy + dy);
    bottomRight = Offset(bottomRight.dx + dx, bottomRight.dy + dy);
  }

  double _getDiagonal(Corner corner) {
    switch (corner) {
      case Corner.topLeft:
        return (bottomRight - topLeft).distance;
      case Corner.topRight:
        return (bottomLeft - topRight).distance;
      case Corner.bottomLeft:
        return (topRight - bottomLeft).distance;
      case Corner.bottomRight:
        return (topLeft - bottomRight).distance;
      case Corner.none:
        return 0;
    }
  }

  double _getAngle(Corner corner) {
    switch (corner) {
      case Corner.topLeft:
        return (bottomRight - topLeft).direction;
      case Corner.topRight:
        return (bottomLeft - topRight).direction;
      case Corner.bottomLeft:
        return (topRight - bottomLeft).direction;
      case Corner.bottomRight:
        return (topLeft - bottomRight).direction;
      case Corner.none:
        return 0;
    }
  }

  Map<Corner, double> _getInitialAngles(Offset center) {
    return {
      Corner.topLeft: (topLeft - center).direction,
      Corner.topRight: (topRight - center).direction,
      Corner.bottomLeft: (bottomLeft - center).direction,
      Corner.bottomRight: (bottomRight - center).direction,
      Corner.none: 0,
    };
  }

  Offset _rotatePoint(
    Offset point,
    double initialAngle,
    double rotationAngle,
    Offset center,
  ) {
    return center +
        Offset.fromDirection(
          initialAngle + rotationAngle,
          (point - center).distance,
        );
  }
}
