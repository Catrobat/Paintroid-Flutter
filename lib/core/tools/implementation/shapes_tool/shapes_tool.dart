import 'dart:ui';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class ShapesTool extends Tool {
  bool isRotating;
  BoundingBox boundingBox;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.boundingBox,
    this.isRotating = false,
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
  void onCheckmark() => ();

  @override
  void onPlus() => ();

  @override
  void onRedo() => ();

  @override
  void onUndo() => ();

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
}
