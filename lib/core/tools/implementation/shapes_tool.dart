import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/shape_command.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';
import 'package:paintroid/ui/utils/shape_drawing_utils.dart';
import 'package:paintroid/ui/utils/shape_path_generator.dart';

class ShapesTool extends Tool {
  static const starShapeNumberOfPoints = 5;
  BoundingBox boundingBox;
  ShapeType shapeType;
  ShapeStyle style;
  bool _isInteracting = false;

  static const double _kShapeVisualPadding = 15.0;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.boundingBox,
    this.shapeType = ShapeType.square,
    this.style = ShapeStyle.outline,
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
    final double padding = _calculatePaddingAdjustedForStrokeWidth(strokeWidth);

    final double halfWidth = boundingBox.width / 2;
    final double halfHeight = boundingBox.height / 2;

    switch (shapeType) {
      case ShapeType.square:
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

        command = commandFactory.createSquareShapeCommand(paint, globalTopLeft,
            globalTopRight, globalBottomLeft, globalBottomRight, style);
        break;
      case ShapeType.ellipse:
        final double paddedRadiusX = math.max(0, halfWidth - padding) * 2;
        final double paddedRadiusY = math.max(0, halfHeight - padding) * 2;

        command = commandFactory.createEllipseShapeCommand(
          paint,
          paddedRadiusX,
          paddedRadiusY,
          boundingBox.center,
          style,
          boundingBox.angle,
        );
        break;
      case ShapeType.star:
        final double paddedRadiusX = math.max(0, halfWidth - padding / 2);
        final double paddedRadiusY = math.max(0, halfHeight - padding / 2);
        command = commandFactory.createStarShapeCommand(
          paint,
          starShapeNumberOfPoints,
          boundingBox.angle,
          boundingBox.center,
          style,
          paddedRadiusX,
          paddedRadiusY,
        );
        break;
      case ShapeType.heart:
        final double paddedWidth = math.max(0, boundingBox.width - padding);
        final double paddedHeight = math.max(0, boundingBox.height - padding);
        command = commandFactory.createHeartShapeCommand(
          paint,
          paddedWidth,
          paddedHeight,
          boundingBox.angle,
          boundingBox.center,
          style,
        );
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
    final double padding = _calculatePaddingAdjustedForStrokeWidth(strokeWidth);
    Path? path;

    canvas.save();
    canvas.translate(boundingBox.center.dx, boundingBox.center.dy);
    canvas.rotate(boundingBox.angle);

    final double halfWidth = boundingBox.width / 2;
    final double halfHeight = boundingBox.height / 2;

    switch (shapeType) {
      case ShapeType.square:
        final localPath = Path();
        localPath.moveTo(-halfWidth + padding, -halfHeight + padding);
        localPath.lineTo(halfWidth - padding, -halfHeight + padding);
        localPath.lineTo(halfWidth - padding, halfHeight - padding);
        localPath.lineTo(-halfWidth + padding, halfHeight - padding);
        localPath.close();
        path = localPath;
        break;
      case ShapeType.ellipse:
        final double paddedRadiusX = math.max(0, halfWidth - padding) * 2;
        final double paddedRadiusY = math.max(0, halfHeight - padding) * 2;
        path = Path()
          ..addOval(Rect.fromCenter(
            center: Offset.zero,
            width: paddedRadiusX,
            height: paddedRadiusY,
          ));
        break;
      case ShapeType.star:
        final double paddedRadiusX = math.max(0, halfWidth - padding / 2);
        final double paddedRadiusY = math.max(0, halfHeight - padding / 2);
        path = ShapePathUtils.generateStarPath(
          numberOfPoints: starShapeNumberOfPoints,
          center: Offset.zero,
          angle: 0,
          radiusX: paddedRadiusX,
          radiusY: paddedRadiusY,
        );
        break;
      case ShapeType.heart:
        final double paddedWidth = math.max(0, boundingBox.width - padding);
        final double paddedHeight = math.max(0, boundingBox.height - padding);
        path = ShapePathUtils.generateHeartPath(
          width: paddedWidth,
          height: paddedHeight,
          center: Offset.zero,
          angle: 0,
        );
        break;
    }

    ShapeDrawingUtils.drawPathWithStyle(
      canvas: canvas,
      path: path,
      basePaint: paint,
      style: style,
    );

    canvas.restore();
  }

  void drawGuides(Canvas canvas) {
    boundingBox.drawGuides(canvas);
  }

  double _calculatePaddingAdjustedForStrokeWidth(double strokeWidth) =>
      (strokeWidth / 2) + _kShapeVisualPadding;
}
