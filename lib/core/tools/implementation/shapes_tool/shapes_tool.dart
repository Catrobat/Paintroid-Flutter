import 'dart:ui';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/circle_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/rectangle_shape_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class ShapesTool extends Tool {
  bool isRotating;
  BoundingBox boundingBox;
  ShapeType shapeType;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.boundingBox,
    this.isRotating = false,
    this.shapeType = ShapeType.rectangle,
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
    switch (shapeType) {
      case ShapeType.rectangle:
        commandManager.addGraphicCommand(
          RectangleShapeCommand(
            GraphicFactory.copyPaintWith(
              original: paint,
              strokeJoin: StrokeJoin.miter,
            ),
            boundingBox.getPaddedTopLeft(padding: paint.strokeWidth),
            boundingBox.getPaddedTopRight(padding: paint.strokeWidth),
            boundingBox.getPaddedBottomLeft(padding: paint.strokeWidth),
            boundingBox.getPaddedBottomRight(padding: paint.strokeWidth),
          ),
        );
        break;
      case ShapeType.circle:
        commandManager.addGraphicCommand(
          CircleShapeCommand(
            GraphicFactory.copyPaintWith(
              original: paint,
              strokeJoin: StrokeJoin.miter,
            ),
            boundingBox.getPaddedRadius(padding: paint.strokeWidth),
            boundingBox.center,
          ),
        );
        break;
    }
    commandManager.clearRedoStack();
  }

  @override
  void onPlus() => {};

  @override
  void onRedo() => commandManager.redo();

  @override
  void onUndo() => commandManager.undo();

  void drawGuides(Canvas canvas) {
    drawRectangle(canvas, GraphicFactory.boundingBoxPaint, isBoundingBox: true);
    if (isRotating) {
      _drawCircumscribingCircle(canvas);
    }
    _drawCornerCircles(canvas, GraphicFactory.anchorPointPaint);
  }

  void drawRectangle(Canvas canvas, Paint paint, {bool isBoundingBox = false}) {
    canvas.drawPath(
      boundingBox.getPath(padding: isBoundingBox ? 0 : paint.strokeWidth),
      GraphicFactory.copyPaintWith(
        original: paint,
        strokeJoin: StrokeJoin.miter,
      ),
    );
  }

  void _drawCornerCircles(Canvas canvas, Paint paint) {
    final radius = boundingBox.boundingBoxCornerRadius;
    canvas.drawCircle(boundingBox.topLeft, radius, paint);
    canvas.drawCircle(boundingBox.topRight, radius, paint);
    canvas.drawCircle(boundingBox.bottomLeft, radius, paint);
    canvas.drawCircle(boundingBox.bottomRight, radius, paint);
  }

  void _drawCircumscribingCircle(Canvas canvas) {
    canvas.drawCircle(
      boundingBox.center,
      boundingBox.topLeftBottomRightDiagonal / 2,
      GraphicFactory.circumferencePaint,
    );
  }

  void drawCircle(Canvas canvas, Paint paint) => canvas.drawCircle(
        boundingBox.center,
        boundingBox.getPaddedRadius(padding: paint.strokeWidth),
        paint,
      );
}
