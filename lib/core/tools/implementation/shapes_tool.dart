import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/shape_command.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class ShapesTool extends Tool {
  BoundingBox boundingBox;
  ShapeType shapeType;

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
  void onDown(Offset point, Paint paint) => boundingBox.setActiveCorner(point);

  @override
  void onDrag(Offset point, Paint paint) {
    if (shapeType != ShapeType.circle) {
      boundingBox.update(point);
      return;
    }
    if (boundingBox.activeCorner == BoundingBoxCorner.none) {
      boundingBox.update(point);
      return;
    }
    final Offset center = boundingBox.center;
    final double radius = (point - center).distance;
    final double halfSize = radius;

    boundingBox.updateCorners(
      center.translate(-halfSize, -halfSize),
      center.translate(halfSize, -halfSize),
      center.translate(-halfSize, halfSize),
      center.translate(halfSize, halfSize),
    );
  }

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
    }
  }

  void drawGuides(Canvas canvas) {
    boundingBox.drawBoundingBox(canvas);
  }

  double _calculatePaddingAdjustedForStrokeWidth(double strokeWidth) =>
      switch (shapeType) {
        ShapeType.square => strokeWidth * sqrt2 / 2,
        ShapeType.circle => strokeWidth / 2
      };
}
