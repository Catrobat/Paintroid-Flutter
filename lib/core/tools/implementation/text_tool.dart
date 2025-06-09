import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';

extension TextToolExtensions on TextToolOptionsStateData {
  TextStyle toTextStyle(Color color) => TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
    decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
  );
}

class TextTool extends Tool {
  final BoundingBox boundingBox;
  final Ref _ref;

  TextToolOptionsStateData get textOptions =>
      _ref.read(textToolOptionsStateProvider);

  String currentText = '';
  bool isEditing = false;
  static const double minFontSize = 10.0;
  static const double maxFontSize = 600.0;

  TextTool({
    required super.commandManager,
    required super.commandFactory,
    required super.type,
    required this.boundingBox,
    required Ref ref,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  }) : _ref = ref;

  @override
  void onDown(Offset point, Paint paint) {
    boundingBox.setActiveCorner(point);
    isEditing = true;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (isEditing) {
      final double previousHeight =
          (boundingBox.topLeft - boundingBox.bottomLeft).distance;
      final double initialRatio =
          previousHeight > 0 ? textOptions.fontSize / (previousHeight / 2.0) : 1.0;

      boundingBox.update(point);

      final double newHeight =
          (boundingBox.topLeft - boundingBox.bottomLeft).distance;
      if (newHeight > 0) {
        final double newFontSize =
            (newHeight / 2.0 * initialRatio).clamp(minFontSize, maxFontSize);

        if (newFontSize != textOptions.fontSize && isEditing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _ref
                .read(textToolOptionsStateProvider.notifier)
                .setFontSize(newFontSize);
          });
        }
      }
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
      final double rotationAngle =
          (boundingBox.topRight - boundingBox.topLeft).direction;

      final command = commandFactory.createTextCommand(
        textOffset,
        trimmedText,
        textOptions.toTextStyle(paint.color),
        textOptions.fontSize,
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
    final textStyle = textOptions.toTextStyle(paint.color);
    final textPainter = TextPainter(
      text: TextSpan(text: currentText, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0);

    final double textWidth = textPainter.width;
    final double textHeight = textPainter.height;

    final double padding = 20.0;
    final double boxWidth = textWidth + (padding * 2);
    final double boxHeight = textHeight + (padding * 2);

    final Offset center = boundingBox.center;
    final double angle = (boundingBox.topRight - boundingBox.topLeft).direction;

    final double halfWidth = boxWidth / 2;
    final double halfHeight = boxHeight / 2;

    final double cosAngle = math.cos(angle);
    final double sinAngle = math.sin(angle);

    final Offset topLeft = center +
        Offset(
          -halfWidth * cosAngle + halfHeight * sinAngle,
          -halfWidth * sinAngle - halfHeight * cosAngle,
        );
    final Offset topRight = center +
        Offset(
          halfWidth * cosAngle + halfHeight * sinAngle,
          halfWidth * sinAngle - halfHeight * cosAngle,
        );
    final Offset bottomLeft = center +
        Offset(
          -halfWidth * cosAngle - halfHeight * sinAngle,
          -halfWidth * sinAngle + halfHeight * cosAngle,
        );
    final Offset bottomRight = center +
        Offset(
          halfWidth * cosAngle - halfHeight * sinAngle,
          halfWidth * sinAngle + halfHeight * cosAngle,
        );

    boundingBox.updateCorners(topLeft, topRight, bottomLeft, bottomRight);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final Offset centeredTextOffset =
        Offset(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, centeredTextOffset);
    canvas.restore();
  }

  TextTool copyWith({
    String? currentText,
    bool? isEditing,
    BoundingBox? boundingBox,
    Ref? ref,
  }) {
    return TextTool(
      commandManager: commandManager,
      commandFactory: commandFactory,
      type: type,
      boundingBox: boundingBox ?? this.boundingBox,
      ref: ref ?? _ref,
    )
      ..currentText = currentText ?? this.currentText
      ..isEditing = isEditing ?? this.isEditing;
  }
}
