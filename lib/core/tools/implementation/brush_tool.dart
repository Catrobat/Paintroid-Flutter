import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/models/path_model.dart';
import 'package:paintroid/core/tools/tool.dart';

class BrushTool extends Tool {
  final GraphicFactory graphicFactory;
  final bool isCursor;
  bool isDrawing = false;

  @visibleForTesting
  late PathModel pathToDraw;

  BrushTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    this.isCursor = false,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    isDrawing = true;
    pathToDraw = graphicFactory.createPathModel()
      ..moveTo(point.dx, point.dy);
    Paint savedPaint = graphicFactory.copyPaint(paint);
    final command = commandFactory.createPathCommand(
      pathToDraw,
      savedPaint,
      isCursor: isCursor,
    );
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset point, Paint paint) {
    isDrawing = false;
    if (pathToDraw.getBounds().size == Size.zero) {
      pathToDraw.lineTo(point.dx, point.dy);
      pathToDraw.close();
    }
  }

  @override
  void onCancel() {
    isDrawing = false;
    commandManager.discardLastCommand();
  }

  @override
  void onCheckmark(Paint paint) {}

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
}
