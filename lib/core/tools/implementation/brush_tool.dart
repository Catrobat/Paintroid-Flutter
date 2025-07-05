import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/tool.dart';

class BrushTool extends Tool {
  final GraphicFactory graphicFactory;
  bool isDrawing = false;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;

  BrushTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    isDrawing = true;
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);
    Paint savedPaint = graphicFactory.copyPaint(paint);
    final command = commandFactory.createPathCommand(pathToDraw, savedPaint);
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset point, Paint paint) {
    isDrawing = false;
    if (pathToDraw.path.getBounds().size == Size.zero) {
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
