import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/text_tool/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class TextTool extends Tool {
  bool isRotating;
  BoundingBox boundingBox;

  TextTool({
    required super.commandManager,
    required super.commandFactory,
    required this.graphicFactory,
    required super.type,
    required this.boundingBox,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
    this.isRotating = false,
  });

  String? currentText;
  Offset? currentPosition;
  bool isEditing = false;
  final GraphicFactory graphicFactory;
  Paint paint = Paint();

  @override
  void onDown(Offset point, Paint paint) {
    paint = paint;
    boundingBox.setActiveCorner(point, isRotating: isRotating);
    isEditing = true;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (isEditing) {
      boundingBox.update(point, isRotating: isRotating);
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    boundingBox.resetActiveCorner();
  }

  @override
  void onCancel() {
    currentPosition = null;
    currentText = null;
    isEditing = false;
  }

  @override
  void onCheckmark(Paint paint) {
    if (currentText != null) {
      final textOffset = boundingBox.center;

      final rectangleHeight =
          (boundingBox.bottomLeft.dy - boundingBox.topLeft.dy).abs();

      final textStyle = TextStyle(
        color: paint.color,
        fontSize: rectangleHeight / 2,
      );

      final command = commandFactory.createAddTextCommand(
        textOffset,
        currentText!,
        textStyle,
        paint,
      );
      commandManager.addGraphicCommand(command);
      commandManager.clearRedoStack();
      currentText = null;
      currentPosition = null;
      isEditing = false;
    }
  }

  @override
  void onPlus() {}

  @override
  void onRedo() {}

  @override
  void onUndo() {}

  void drawGuides(Canvas canvas) {
    drawRectangle(canvas, GraphicFactory.boundingBoxPaint, isBoundingBox: true);
    _drawCornerCircles(canvas, GraphicFactory.anchorPointPaint);

    final rectangleHeight =
        (boundingBox.bottomLeft.dy - boundingBox.topLeft.dy).abs();

    final textStyle = TextStyle(
      color: paint.color,
      fontSize: rectangleHeight / 2,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: currentText, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: boundingBox.topRight.dx - boundingBox.topLeft.dx,
    );

    final textOffset = boundingBox.center -
        Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
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

  void drawCircle(Canvas canvas, Paint paint) => canvas.drawCircle(
        boundingBox.center,
        boundingBox.getPaddedRadius(padding: paint.strokeWidth),
        paint,
      );

  void _drawCornerCircles(Canvas canvas, Paint paint) {
    final radius = boundingBox.boundingBoxCornerRadius;
    canvas.drawCircle(boundingBox.topLeft, radius, paint);
    canvas.drawCircle(boundingBox.topRight, radius, paint);
    canvas.drawCircle(boundingBox.bottomLeft, radius, paint);
    canvas.drawCircle(boundingBox.bottomRight, radius, paint);
  }

  TextTool copyWith({
    String? currentText,
    Offset? currentPosition,
    bool? isEditing,
  }) {
    return TextTool(
      commandManager: commandManager,
      commandFactory: commandFactory,
      graphicFactory: graphicFactory,
      type: type,
      boundingBox: boundingBox,
      isRotating: isRotating,
      hasAddFunctionality: hasAddFunctionality,
      hasFinalizeFunctionality: hasFinalizeFunctionality,
    )
      ..currentText = currentText ?? this.currentText
      ..currentPosition = currentPosition ?? this.currentPosition
      ..isEditing = isEditing ?? this.isEditing;
  }
}
