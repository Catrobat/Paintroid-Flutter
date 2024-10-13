import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/shape_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class ShapesTool extends Tool {
  static const starShapeNumberOfPoints = 5;
  bool isRotating;
  BoundingBox boundingBox;
  ShapeType shapeType;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.boundingBox,
    this.isRotating = false,
    this.shapeType = ShapeType.square,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  @override
  void onDown(Offset point, Paint paint) =>
      boundingBox.setActiveCorner(point, isRotating: isRotating);

  @override
  void onDrag(Offset point, Paint paint) =>
      boundingBox.update(point, isRotating: isRotating);

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
        );
        break;
      case ShapeType.circle:
        final radius = boundingBox.innerRadius - padding;
        command = commandFactory.createCircleShapeCommand(
          paint,
          radius,
          boundingBox.center,
        );
        break;
      case ShapeType.star:
        final radius = boundingBox.innerRadius - padding;
        command = commandFactory.createStarShapeCommand(
          paint,
          starShapeNumberOfPoints,
          radius,
          boundingBox.angle,
          boundingBox.center,
        );
        break;
      case ShapeType.heart:
        command = commandFactory.createHeartShapeCommand(
          paint,
          boundingBox.width,
          boundingBox.height,
          boundingBox.angle,
          boundingBox.center,
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
    switch (shapeType) {
      case ShapeType.square:
        canvas.drawPath(boundingBox.getPath(padding: padding), paint);
        break;
      case ShapeType.circle:
        final radius = boundingBox.innerRadius - padding;
        canvas.drawCircle(boundingBox.center, radius, paint);
        break;
      case ShapeType.star:
        final radius = boundingBox.innerRadius - padding;
        final path = boundingBox.getStarPath(starShapeNumberOfPoints, radius);
        canvas.drawPath(path, paint);
      case ShapeType.heart:
        final path = boundingBox.getHeartPath();
        canvas.drawPath(path, paint);
    }
  }

  void drawGuides(Canvas canvas) => this
    .._drawGuideBox(canvas)
    .._drawGuideCircle(canvas)
    .._drawAnchorCircles(canvas);

  void _drawGuideBox(Canvas canvas) =>
      canvas.drawPath(boundingBox.getPath(), GraphicFactory.guidePaint);

  void _drawGuideCircle(Canvas canvas) {
    if (isRotating) {
      canvas.drawCircle(
        boundingBox.center,
        boundingBox.outerRadius,
        GraphicFactory.guidePaint,
      );
    }
  }

  void _drawAnchorCircles(Canvas canvas) {
    final radius = boundingBox.anchorRadius;
    final paint = GraphicFactory.anchorPaint;
    canvas.drawCircle(boundingBox.topLeft, radius, paint);
    canvas.drawCircle(boundingBox.topRight, radius, paint);
    canvas.drawCircle(boundingBox.bottomLeft, radius, paint);
    canvas.drawCircle(boundingBox.bottomRight, radius, paint);
  }

  double _calculatePaddingAdjustedForStrokeWidth(double strokeWidth) =>
      switch (shapeType) {
        ShapeType.square => strokeWidth * sqrt2 / 2,
        ShapeType.circle => strokeWidth / 2,
        ShapeType.star => strokeWidth * sqrt2 / 2,
        ShapeType.heart => strokeWidth / 2,
      };
}
