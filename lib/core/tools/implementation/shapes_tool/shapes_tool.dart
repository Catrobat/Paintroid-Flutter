import 'dart:ui';

import 'package:paintroid/core/tools/tool.dart';

class ShapesTool extends Tool {
  Rect boundingBox;
  bool isRotating;
  bool isTranslatingAndScaling;
  bool movingBoundingBox = false;
  bool movingTopLeftCorner = false;
  bool movingTopRightCorner = false;
  bool movingBottomLeftCorner = false;
  bool movingBottomRightCorner = false;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
    this.boundingBox = Rect.zero,
    this.isRotating = false,
    this.isTranslatingAndScaling = true,
  });

  ShapesTool copyWith({
    Rect? boundingBox,
    bool? isRotating,
    bool? isTranslatingAndScaling,
  }) {
    return ShapesTool(
      commandFactory: commandFactory,
      commandManager: commandManager,
      type: type,
      hasAddFunctionality: hasAddFunctionality,
      hasFinalizeFunctionality: hasFinalizeFunctionality,
      boundingBox: boundingBox ?? this.boundingBox,
      isRotating: isRotating ?? this.isRotating,
      isTranslatingAndScaling:
          isTranslatingAndScaling ?? this.isTranslatingAndScaling,
    );
  }

  @override
  void onDown(Offset point, Paint paint) {
    if (isTranslatingAndScaling) _setTranslationAndScalingFlags(point);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    _updateBoundingBox(point);
  }

  @override
  void onUp(Offset point, Paint paint) {
    _updateBoundingBox(point);
    _resetTranslationAndScalingFlags();
  }

  @override
  void onCancel() {
    _resetTranslationAndScalingFlags();
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

    if ((point - boundingBox.topLeft).distance < circleRadius) {
      movingTopLeftCorner = true;
    } else if ((point - boundingBox.topRight).distance < circleRadius) {
      movingTopRightCorner = true;
    } else if ((point - boundingBox.bottomLeft).distance < circleRadius) {
      movingBottomLeftCorner = true;
    } else if ((point - boundingBox.bottomRight).distance < circleRadius) {
      movingBottomRightCorner = true;
    } else {
      movingBoundingBox = true;
    }
    _updateBoundingBox(point);
  }

  void _updateBoundingBox(Offset point) {
    if (isTranslatingAndScaling) {
      if (movingTopLeftCorner) {
        boundingBox = Rect.fromPoints(point, boundingBox.bottomRight);
      } else if (movingTopRightCorner) {
        boundingBox = Rect.fromPoints(boundingBox.bottomLeft, point);
      } else if (movingBottomLeftCorner) {
        boundingBox = Rect.fromPoints(point, boundingBox.topRight);
      } else if (movingBottomRightCorner) {
        boundingBox = Rect.fromPoints(boundingBox.topLeft, point);
      } else if (movingBoundingBox) {
        final dx = point.dx - boundingBox.center.dx;
        final dy = point.dy - boundingBox.center.dy;
        boundingBox = boundingBox.translate(dx, dy);
      }
    }
  }

  void _resetTranslationAndScalingFlags() {
    movingTopLeftCorner = false;
    movingTopRightCorner = false;
    movingBottomLeftCorner = false;
    movingBottomRightCorner = false;
    movingBoundingBox = false;
  }
}
