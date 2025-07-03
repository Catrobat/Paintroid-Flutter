import 'dart:math';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/shape_command.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';

class ShapesTool extends Tool {
  BoundingBox boundingBox;
  ShapeType shapeType;
  bool _isInteracting = false;

  static const double _kShapeVisualPadding = 15.0;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.boundingBox,
    this.shapeType = ShapeType.square,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  @override
  void onDown(Offset point, Paint paint) {
    boundingBox.determineAction(point);
    _isInteracting = boundingBox.currentAction != BoundingBoxAction.none;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (_isInteracting) {
      boundingBox.updateDrag(point);
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    if (_isInteracting) {
      boundingBox.endDrag();
      _isInteracting = false;
    }
  }

  @override
  void onCancel() {
    if (_isInteracting) {
      boundingBox.endDrag();
      _isInteracting = false;
    }
  }

  @override
  void onCheckmark(Paint paint) {
    ShapeCommand command;
    final double strokeWidth = paint.strokeWidth;

    switch (shapeType) {
      case ShapeType.square:
        final double padding =
            _calculatePaddingAdjustedForStrokeWidth(strokeWidth);
        final Offset center = boundingBox.center;
        final double boxWidth = boundingBox.width;
        final double boxHeight = boundingBox.height;
        final double angle = boundingBox.angle;

        final double halfWidth = boxWidth / 2;
        final double halfHeight = boxHeight / 2;

        final Offset localTopLeftPadded =
            Offset(-halfWidth + padding, -halfHeight + padding);
        final Offset localTopRightPadded =
            Offset(halfWidth - padding, -halfHeight + padding);
        final Offset localBottomLeftPadded =
            Offset(-halfWidth + padding, halfHeight - padding);
        final Offset localBottomRightPadded =
            Offset(halfWidth - padding, halfHeight - padding);

        final Offset globalTopLeft =
            localTopLeftPadded.localToGlobal(center, angle);
        final Offset globalTopRight =
            localTopRightPadded.localToGlobal(center, angle);
        final Offset globalBottomLeft =
            localBottomLeftPadded.localToGlobal(center, angle);
        final Offset globalBottomRight =
            localBottomRightPadded.localToGlobal(center, angle);

        command = commandFactory.createSquareShapeCommand(
          paint,
          globalTopLeft,
          globalTopRight,
          globalBottomLeft,
          globalBottomRight,
        );
        break;
      case ShapeType.ellipse:
        final double strokePadding =
            _calculatePaddingAdjustedForStrokeWidth(strokeWidth);
        final double ellipseRadiusX = boundingBox.width / 2 - strokePadding;
        final double ellipseRadiusY = boundingBox.height / 2 - strokePadding;

        command = commandFactory.createEllipseShapeCommand(
          paint,
          math.max(0, ellipseRadiusX),
          math.max(0, ellipseRadiusY),
          boundingBox.center,
          boundingBox.angle,
        );
        break;
    }
    commandManager.addGraphicCommand(command);
    commandManager.clearRedoStack();
  }

  @override
  void onPlus() => {};

  @override
  void onRedo() => commandManager.redo();

  @override
  void onUndo() => commandManager.undo();

  void drawShape(Canvas canvas, Paint paint) {
    final double strokeWidth = paint.strokeWidth;
    final padding = _calculatePaddingAdjustedForStrokeWidth(strokeWidth);

    canvas.save();
    canvas.translate(boundingBox.center.dx, boundingBox.center.dy);
    canvas.rotate(boundingBox.angle);

    final double halfWidth = boundingBox.width / 2;
    final double halfHeight = boundingBox.height / 2;

    switch (shapeType) {
      case ShapeType.square:
        final path = Path();
        path.moveTo(-halfWidth + padding, -halfHeight + padding);
        path.lineTo(halfWidth - padding, -halfHeight + padding);
        path.lineTo(halfWidth - padding, halfHeight - padding);
        path.lineTo(-halfWidth + padding, halfHeight - padding);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.ellipse:
        final double paddedHalfWidth = halfWidth - padding;
        final double paddedHalfHeight = halfHeight - padding;
        final double effectivePaddedHalfWidth = max(0, paddedHalfWidth);
        final double effectivePaddedHalfHeight = max(0, paddedHalfHeight);

        final Rect ovalRect = Rect.fromCenter(
          center: Offset.zero,
          width: 2 * effectivePaddedHalfWidth,
          height: 2 * effectivePaddedHalfHeight,
        );
        canvas.drawOval(ovalRect, paint);
        break;
    }
    canvas.restore();
  }

  void drawGuides(Canvas canvas) {
    boundingBox.drawGuides(canvas);
  }

  double _calculatePaddingAdjustedForStrokeWidth(double strokeWidth) =>
      (strokeWidth / 2) + _kShapeVisualPadding;
}
