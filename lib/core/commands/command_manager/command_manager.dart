import 'dart:ui';

import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/tools/line_tool/vertex.dart';
import 'package:paintroid/core/tools/line_tool/vertex_stack.dart';
import 'package:paintroid/core/tools/tool_data.dart';

class CommandManager implements ICommandManager {
  CommandManager();

  final List<Command> _undoStack = [];
  final List<Command> _redoStack = [];

  @override
  void addGraphicCommand(GraphicCommand command) {
    _undoStack.add(command);
  }

  @override
  void setUndoStack(List<Command> commands) {
    _undoStack.clear();
    _undoStack.addAll(commands);
  }

  @override
  void executeLastCommand(Canvas canvas) {
    if (_undoStack.isEmpty) return;
    final lastCommand = _undoStack.last;
    if (lastCommand is GraphicCommand) {
      lastCommand.call(canvas);
    }
  }

  @override
  void executeAllCommands(Canvas canvas) {
    for (final command in _undoStack) {
      if (command is GraphicCommand) {
        command.call(canvas);
      }
    }
  }

  @override
  void discardLastCommand() {
    if (_undoStack.isNotEmpty) _undoStack.removeLast();
  }

  @override
  void clearUndoStack({Iterable<Command>? newCommands}) {
    _undoStack.clear();
    if (newCommands != null) {
      _undoStack.addAll(newCommands);
    }
  }

  @override
  void clearRedoStack() {
    _redoStack.clear();
  }

  @override
  void drawLineToolGhostPaths(
    Canvas canvas,
    LineCommand? ingoingGhostPathCommand,
    LineCommand? outgoingGhostPathCommand,
  ) {
    ingoingGhostPathCommand?.call(canvas);
    outgoingGhostPathCommand?.call(canvas);
  }

  @override
  void drawLineToolVertices(Canvas canvas, VertexStack vertexStack) {
    for (var vertex in vertexStack) {
      canvas.drawCircle(
        vertex.vertexCenter,
        Vertex.VERTEX_RADIUS,
        Vertex.getVertexPaint(),
      );
    }
  }

  @override
  Command redo() {
    final lastCommand = _redoStack.removeLast();
    _undoStack.add(lastCommand);
    return lastCommand;
  }

  @override
  void undo() {
    final lastCommand = _undoStack.removeLast();
    _redoStack.add(lastCommand);
  }

  @override
  List<Command> get redoStack => _redoStack;

  @override
  List<Command> get undoStack => _undoStack;

  @override
  ToolData getNextTool(ActionType actionType) {
    Command? command;
    switch (actionType) {
      case ActionType.UNDO:
        command = _undoStack.last;
        break;
      case ActionType.REDO:
        command = _redoStack.last;
        break;
    }

    ///TODO implement for all tools after implementing unique commands
    if (command.runtimeType == LineCommand) {
      return ToolData.LINE;
    } else {
      return ToolData.BRUSH;
    }
  }

  @override
  List<LineCommand> getTopLineCommandSequence() {
    final List<LineCommand> lineCommands = [];

    for (final command in _undoStack.reversed) {
      if (command is! LineCommand) break;
      lineCommands.add(command);
      if (command.isSourcePath) break;
    }

    return lineCommands.reversed.toList();
  }
}
