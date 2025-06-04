import 'package:flutter/material.dart';

import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

class TextTool extends Tool {
  BoundingBox boundingBox;
  String fontFamily;
  bool isBold;
  bool isItalic;

  TextTool({
    required super.commandManager,
    required super.commandFactory,
    required super.type,
    required this.boundingBox,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
    this.fontFamily = 'Roboto',
    this.isBold = false,
    this.isItalic = false,
  });

  String currentText = '';
  bool isEditing = false;
  static const double _minFontSize = 10.0;
  static const double _maxFontSize = 600.0;

  @override
  void onDown(Offset point, Paint paint) {
    boundingBox.setActiveCorner(point);
    isEditing = true;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (isEditing) {
      boundingBox.update(point);
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    boundingBox.resetActiveCorner();
  }

  @override
  void onCancel() {
    currentText = '';
    isEditing = false;
  }

  @override
  void onCheckmark(Paint paint) {
    final String trimmedText = currentText.trim();
    if (trimmedText.isNotEmpty) {
      final textOffset = boundingBox.center;

      final double visualHeight =
          (boundingBox.topLeft - boundingBox.bottomLeft).distance;
      final double rotationAngle =
          (boundingBox.topRight - boundingBox.topLeft).direction;

      final double calculatedFontSize =
          visualHeight > 0 ? visualHeight / 2.0 : _minFontSize;
      final double clampedFontSize =
          calculatedFontSize.clamp(_minFontSize, _maxFontSize);

      final textStyle = TextStyle(
        color: paint.color,
        fontSize: clampedFontSize,
        fontFamily: fontFamily,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      );

      final command = commandFactory.createTextCommand(
        textOffset,
        trimmedText,
        textStyle,
        paint,
        rotationAngle,
      );
      commandManager.addGraphicCommand(command);
      commandManager.clearRedoStack();
      currentText = '';
      isEditing = false;
    }
  }

  @override
  void onPlus() {}

  @override
  void onRedo() => commandManager.redo();

  @override
  void onUndo() => commandManager.undo();

  void drawGuides(Canvas canvas, Paint paint) {
    paintText(canvas, paint);
    boundingBox.drawBoundingBox(canvas);
  }

  void paintText(Canvas canvas, Paint paint) {
    final double visualWidth =
        (boundingBox.topRight - boundingBox.topLeft).distance;
    final double visualHeight =
        (boundingBox.topLeft - boundingBox.bottomLeft).distance;

    final double calculatedFontSize =
        visualHeight > 0 ? visualHeight / 2.0 : _minFontSize;
    final double clampedFontSize =
        calculatedFontSize.clamp(_minFontSize, _maxFontSize);

    final textStyle = TextStyle(
      color: paint.color,
      fontSize: clampedFontSize,
      fontFamily: fontFamily,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: currentText, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: visualWidth > 0 ? visualWidth : 0.0,
    );

    canvas.save();
    canvas.translate(boundingBox.center.dx, boundingBox.center.dy);
    final double rotationAngle =
        (boundingBox.topRight - boundingBox.topLeft).direction;
    canvas.rotate(rotationAngle);
    final Offset centeredTextOffset =
        Offset(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, centeredTextOffset);
    canvas.restore();
  }

  TextTool copyWith({
    String? currentText,
    bool? isEditing,
    String? fontFamily,
    bool? isBold,
    bool? isItalic,
    BoundingBox? boundingBox,
  }) {
    return TextTool(
      commandManager: commandManager,
      commandFactory: commandFactory,
      type: type,
      boundingBox: boundingBox ?? this.boundingBox,
      hasAddFunctionality: hasAddFunctionality,
      hasFinalizeFunctionality: hasFinalizeFunctionality,
      fontFamily: fontFamily ?? this.fontFamily,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
    )
      ..currentText = currentText ?? this.currentText
      ..isEditing = isEditing ?? this.isEditing;
  }
}
