import 'dart:ui';

import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/tools/line_tool/vertex_stack.dart';
import 'package:paintroid/core/tools/tool_data.dart';

enum ActionType { UNDO, REDO }

abstract class ICommandManager {
  List<Command> get undoStack;

  List<Command> get redoStack;

  void setUndoStack(List<Command> commands);

  void addGraphicCommand(GraphicCommand command);

  void executeLastCommand(Canvas canvas);

  void executeAllCommands(Canvas canvas);

  void discardLastCommand();

  void clearUndoStack({Iterable<Command>? newCommands});

  void clearRedoStack();

  void drawLineToolGhostPaths(
    Canvas canvas,
    LineCommand? ingoingGhostPathCommand,
    LineCommand? outgoingGhostPathCommand,
  );

  void drawLineToolVertices(Canvas canvas, VertexStack vertexStack);

  ToolData getNextTool(ActionType actionType);

  void undo();

  Command redo();

  List<LineCommand> getTopLineCommandSequence();
}
