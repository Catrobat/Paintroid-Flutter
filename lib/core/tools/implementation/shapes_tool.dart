import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/shape_command.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/ui/utils/shape_drawing_utils.dart';

class ShapesTool extends Tool {
  static const starShapeNumberOfPoints = 5;
  BoundingBox boundingBox;
  ShapeType shapeType;
  ShapeStyle style;

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
  void onDown(Offset point, Paint paint) => boundingBox.setActiveCorner(point);

  @override
  void onDrag(Offset point, Paint paint) => boundingBox.update(point);

  @override
  void onUp(Offset point, Paint paint) => boundingBox.resetActiveCorner();

  @override
  void onCancel() => boundingBox.resetActiveCorner();

  @override
  void onCheckmark(Paint paint) {
    ShapeCommand command;
    final padding = _calculatePaddingAdjustedForStrokeWidth(paint.strokeWidth);
    switch (shapeType) {
      case ShapeType.square:
        command = commandFactory.createSquareShapeCommand(
          paint,
          boundingBox.getPaddedTopLeft(padding: padding),
          boundingBox.getPaddedTopRight(padding: padding),
          boundingBox.getPaddedBottomLeft(padding: padding),
          boundingBox.getPaddedBottomRight(padding: padding),
          style,
        );
        break;
      case ShapeType.oval:
        final double rectWidth = math.max(0.0, boundingBox.width - padding);
        final double rectHeight = math.max(0.0, boundingBox.height - padding);
        command = commandFactory.createOvalShapeCommand(
          paint,
          rectWidth,
          rectHeight,
          boundingBox.center,
          style,
          boundingBox.angle,
        );
        break;
      case ShapeType.star:
        final effectiveRadiusX = max(0.0, (boundingBox.width - padding) / 2);
        final effectiveRadiusY = max(0.0, (boundingBox.height - padding) / 2);
        command = commandFactory.createStarShapeCommand(
          paint,
          starShapeNumberOfPoints,
          boundingBox.angle,
          boundingBox.center,
          style,
          effectiveRadiusX,
          effectiveRadiusY,
        );
        break;

      case ShapeType.heart:
        command = commandFactory.createHeartShapeCommand(
          paint,
          boundingBox.width,
          boundingBox.height,
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
    final padding = _calculatePaddingAdjustedForStrokeWidth(paint.strokeWidth);
    Path? path;

    switch (shapeType) {
      case ShapeType.square:
        path = boundingBox.getPath(padding: padding);
        break;
      case ShapeType.oval:
        final double rectWidth = math.max(0.0, boundingBox.width - padding);
        final double rectHeight = math.max(0.0, boundingBox.height - padding);
        Path ovalPathAtOrigin = Path()
          ..addOval(Rect.fromCenter(
            center: Offset.zero,
            width: rectWidth,
            height: rectHeight,
          ));

        Path rotatedOvalPath = ovalPathAtOrigin;
        if (boundingBox.angle != 0.0) {
          final rotationMatrix = Matrix4.identity()..rotateZ(boundingBox.angle);
          rotatedOvalPath = ovalPathAtOrigin.transform(rotationMatrix.storage);
        }

        path = rotatedOvalPath.shift(boundingBox.center);
        break;
      case ShapeType.star:
        path = boundingBox.getStarPath(starShapeNumberOfPoints, boxPadding: padding);
        break;
      case ShapeType.heart:
        path = boundingBox.getHeartPath();
        break;
    }

    ShapeDrawingUtils.drawPathWithStyle(
      canvas: canvas,
      path: path,
      basePaint: paint,
      style: style,
    );
  }

  void drawGuides(Canvas canvas) => boundingBox.drawBoundingBox(canvas);

  double _calculatePaddingAdjustedForStrokeWidth(double strokeWidth) =>
      switch (shapeType) {
        ShapeType.square => strokeWidth / 2,
        ShapeType.oval => strokeWidth * 2,
        ShapeType.star => strokeWidth * 2,
        ShapeType.heart => strokeWidth,
      };
}
