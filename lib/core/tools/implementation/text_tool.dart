import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';

const double _kTextSizeMagnificationFactor = 3.0;
const double _kBoxOffset = 20.0;
const double _kMinDrawableArea = 1.0;

class TextTool extends Tool {
  BoundingBox boundingBox;
  TextToolOptionsStateData options;
  final GraphicFactory graphicFactory;
  bool isEditing = false;
  final void Function(double newFontSize)? onUserManuallyResized;

  TextTool({
    required super.commandManager,
    required super.commandFactory,
    required this.graphicFactory,
    required super.type,
    required this.boundingBox,
    required this.options,
    this.onUserManuallyResized,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  }) {
    if (options.isAutoSize || options.text.isEmpty) {
      _resizeBoundingBoxToFitText();
    }
  }

  TextStyle _getTextStyle(Color color, {bool useMagnifiedSize = true}) {
    final baseSize = options.fontSize;
    final size =
        useMagnifiedSize ? baseSize * _kTextSizeMagnificationFactor : baseSize;
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: options.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: options.isItalic ? FontStyle.italic : FontStyle.normal,
      decoration:
          options.isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamily: options.fontFamily,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  void _resizeBoundingBoxToFitText() {
    final measure = options.text.isNotEmpty ? options.text : 'T';
    final painter = TextPainter(
      text: TextSpan(text: measure, style: _getTextStyle(Colors.black)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    boundingBox.width = math.max(
      painter.width + 2 * _kBoxOffset,
      BoundingBox.minimalBoxSize,
    );
    boundingBox.height = math.max(
      painter.height + 2 * _kBoxOffset,
      BoundingBox.minimalBoxSize,
    );
  }

  void _calculateAndNotifyNewFontSize() {
    if (onUserManuallyResized == null) return;
    final measure = options.text.isNotEmpty ? options.text : 'T';
    final painter = TextPainter(
      text: TextSpan(text: measure, style: _getTextStyle(Colors.black)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textW = painter.width;
    final textH = painter.height;
    if (textW < _kMinDrawableArea || textH < _kMinDrawableArea) return;

    final drawableW =
        math.max(_kMinDrawableArea, boundingBox.width - 2 * _kBoxOffset);
    final drawableH =
        math.max(_kMinDrawableArea, boundingBox.height - 2 * _kBoxOffset);

    final scaleX = drawableW / textW;
    final scaleY = drawableH / textH;
    final scale = (scaleX + scaleY) / 2;

    final newFontSize = options.fontSize * scale;
    onUserManuallyResized!(newFontSize);
  }

  @override
  void onDown(Offset point, Paint paint) {
    boundingBox.determineAction(point);
    isEditing = boundingBox.currentAction != BoundingBoxAction.none;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (!isEditing) return;
    boundingBox.updateDrag(point);
    if (boundingBox.currentAction == BoundingBoxAction.resize) {
      _calculateAndNotifyNewFontSize();
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    final prevAction = boundingBox.currentAction;
    boundingBox.endDrag();

    if (options.isAutoSize &&
        prevAction != BoundingBoxAction.resize &&
        !isEditing) {
      _resizeBoundingBoxToFitText();
    } else if (prevAction == BoundingBoxAction.resize) {
      _calculateAndNotifyNewFontSize();
    }
    isEditing = false;
  }

  @override
  void onCancel() {
    boundingBox.endDrag();
    isEditing = false;
  }

  @override
  void onCheckmark(Paint paint) {
    final text = options.text;
    if (text.isEmpty) return;

    final center = boundingBox.center;
    final style = _getTextStyle(paint.color);
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textW = painter.width;
    final textH = painter.height;
    final drawableW =
        math.max(_kMinDrawableArea, boundingBox.width - 2 * _kBoxOffset);
    final drawableH =
        math.max(_kMinDrawableArea, boundingBox.height - 2 * _kBoxOffset);

    final scaleX = drawableW / textW;
    final scaleY = drawableH / textH;

    double effectiveAngle = boundingBox.angle;
    if ((boundingBox.angle).abs() < 0.0001 &&
        ((scaleX.isFinite && (scaleX < 0.99 || scaleX > 1.01)) ||
            (scaleY.isFinite && (scaleY < 0.99 || scaleY > 1.01)))) {
      effectiveAngle = 0.005;
    }

    final command = commandFactory.createTextCommand(
      center,
      text,
      style,
      style.fontSize ?? options.fontSize,
      paint,
      effectiveAngle,
      scaleX: scaleX,
      scaleY: scaleY,
    );
    commandManager.addGraphicCommand(command);
    commandManager.clearRedoStack();
    isEditing = false;
  }

  @override
  void onPlus() {}

  @override
  void onRedo() {
    commandManager.redo();
  }

  @override
  void onUndo() {
    commandManager.undo();
  }

  void drawGuides(Canvas canvas, Paint paint) {
    boundingBox.drawGuides(canvas);
    if (options.text.isEmpty) return;

    final style = _getTextStyle(paint.color);
    final painter = TextPainter(
      text: TextSpan(text: options.text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final textW = painter.width;
    final textH = painter.height;
    final boxW =
        math.max(_kMinDrawableArea, boundingBox.width - 2 * _kBoxOffset);
    final boxH =
        math.max(_kMinDrawableArea, boundingBox.height - 2 * _kBoxOffset);

    final scaleX = boxW / textW;
    final scaleY = boxH / textH;

    double effectiveAngle = boundingBox.angle;
    if ((boundingBox.angle).abs() < 0.0001 &&
        ((scaleX.isFinite && (scaleX < 0.99 || scaleX > 1.01)) ||
            (scaleY.isFinite && (scaleY < 0.99 || scaleY > 1.01)))) {
      effectiveAngle = 0.005;
    }

    canvas.save();
    canvas.translate(boundingBox.center.dx, boundingBox.center.dy);
    canvas.rotate(effectiveAngle);
    canvas.scale(scaleX, scaleY);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  void updateOptions(TextToolOptionsStateData newOptions) {
    final old = options;
    options = newOptions;
    if (isEditing) return;

    final textChanged = old.text != options.text ||
        old.fontFamily != options.fontFamily ||
        old.isBold != options.isBold ||
        old.isItalic != options.isItalic ||
        old.isUnderline != options.isUnderline;
    final fontSizeChanged = old.fontSize != options.fontSize;
    final autoSizeChanged = old.isAutoSize != options.isAutoSize;

    if (options.isAutoSize &&
        (textChanged ||
            fontSizeChanged ||
            (autoSizeChanged && options.isAutoSize))) {
      _resizeBoundingBoxToFitText();
    } else if (!options.isAutoSize &&
        textChanged &&
        onUserManuallyResized != null) {
      _calculateAndNotifyNewFontSize();
    }
  }
}
