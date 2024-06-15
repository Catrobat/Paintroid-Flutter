// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/tool.dart';

class BrushTool extends Tool with EquatableMixin {
  BrushTool({
    required super.paint,
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  final GraphicFactory graphicFactory;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;

  @override
  void onDown(Offset point) {
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);
    Paint savedPaint = graphicFactory.copyPaint(paint);
    final command = commandFactory.createPathCommand(pathToDraw, savedPaint);
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset point) {
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

  @override
  List<Object?> get props => [commandManager, commandFactory, graphicFactory];

  BrushTool copyWith({
    Paint? paint,
    CommandFactory? commandFactory,
    ICommandManager? commandManager,
    GraphicFactory? graphicFactory,
    ToolType? type,
  }) {
    return BrushTool(
      paint: paint ?? this.paint,
      commandFactory: commandFactory ?? this.commandFactory,
      commandManager: commandManager ?? this.commandManager,
      graphicFactory: graphicFactory ?? this.graphicFactory,
      type: ToolType.BRUSH,
    );
  }
}
