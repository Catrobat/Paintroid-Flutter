import 'dart:ui';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shapes_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/shapes_tool/shape_types.dart';
import 'package:paintroid/core/tools/tool.dart';

class ShapesTool extends Tool {
  final GraphicFactory graphicFactory;

  ShapesTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  ShapesTool copyWith({
    CommandFactory? commandFactory,
    CommandManager? commandManager,
    GraphicFactory? graphicFactory,
    ToolType? type,
  }) {
    return ShapesTool(
      commandFactory: commandFactory ?? this.commandFactory,
      commandManager: commandManager ?? this.commandManager,
      graphicFactory: graphicFactory ?? this.graphicFactory,
      type: type ?? this.type,
    );
  }

  @override
  void onDown(Offset point, Paint paint) {
    final rectToDraw = Rect.fromCenter(center: point, width: 150, height: 150);
    final savedPaint = graphicFactory.copyPaint(paint);
    final command = ShapesCommand(rectToDraw, ShapeType.rectangle, savedPaint);
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point, Paint paint) {}

  @override
  void onUp(Offset? point, Paint paint) {}

  @override
  void onCancel() {}

  // TODO: implement onCheckmark
  @override
  void onCheckmark() {}

  // TODO: implement onPlus
  @override
  void onPlus() {}

  @override
  void onRedo() => commandManager.redo();

  @override
  void onUndo() => commandManager.undo();
}
