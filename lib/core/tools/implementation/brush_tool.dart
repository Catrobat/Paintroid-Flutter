import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/tool.dart';

class BrushTool extends Tool {
  final GraphicFactory graphicFactory;

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
    if (pathToDraw.path.getBounds().size == Size.zero) {
      pathToDraw.close();
    }
  }

  @override
  void onCancel() {
    commandManager.discardLastCommand();
  }

  @override
  void onCheckmark() {}

  @override
  void onPlus() {}
}
