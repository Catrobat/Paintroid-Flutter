import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:paintroid/command/src/command_factory.dart';
import 'package:paintroid/command/src/command_manager.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/path_with_action_history.dart';
import 'package:paintroid/tool/src/tool.dart';
import 'package:paintroid/tool/src/tool_types.dart';

class BrushTool extends Tool with EquatableMixin {
  BrushTool({
    required super.paint,
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
  });

  final GraphicFactory graphicFactory;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;

  @override
  void onDown(Offset point) {
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);
    Paint savedPaint = graphicFactory.copyPaint(paint);
    final command =
        commandFactory.createDrawPathCommand(pathToDraw, savedPaint);
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset? point) {
    if (pathToDraw.getBounds().size == Size.zero) {
      pathToDraw.close();
    }
  }

  @override
  void onCancel() {
    commandManager.discardLastCommand();
  }

  @override
  List<Object?> get props => [commandManager, commandFactory, graphicFactory];

  BrushTool copyWith({
    Paint? paint,
    CommandFactory? commandFactory,
    CommandManager? commandManager,
    GraphicFactory? graphicFactory,
    ToolType? type,
  }) {
    return BrushTool(
      paint: paint ?? this.paint,
      commandFactory: commandFactory ?? this.commandFactory,
      commandManager: commandManager ?? this.commandManager,
      graphicFactory: graphicFactory ?? this.graphicFactory,
      type: type ?? this.type,
    );
  }
}
