import 'dart:ui';

import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/text_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/star_shape_command.dart';
import 'package:paintroid/core/tools/line_tool/vertex.dart';
import 'package:paintroid/core/tools/line_tool/vertex_stack.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';

enum ActionType { UNDO, REDO }

class CommandManager {
  CommandManager();

  final List<Command> _undoStack = [];
  final List<Command> _redoStack = [];

  void addGraphicCommand(GraphicCommand command) {
    _undoStack.add(command);
  }

  void setUndoStack(List<Command> commands) {
    _undoStack.clear();
    _undoStack.addAll(commands);
  }

  void executeLastCommand(Canvas canvas) {
    if (_undoStack.isEmpty) return;
    final lastCommand = _undoStack.last;
    if (lastCommand is GraphicCommand) {
      lastCommand.call(canvas);
    }
  }

  void executeAllCommands(Canvas canvas) {
    for (final command in _undoStack) {
      if (command is GraphicCommand) {
        command.call(canvas);
      }
    }
  }

  void discardLastCommand() {
    if (_undoStack.isNotEmpty) _undoStack.removeLast();
  }

  void clearUndoStack({Iterable<Command>? newCommands}) {
    _undoStack.clear();
    if (newCommands != null) {
      _undoStack.addAll(newCommands);
    }
  }

  void clearRedoStack() {
    _redoStack.clear();
  }

  void drawLineToolGhostPaths(
    Canvas canvas,
    LineCommand? ingoingGhostPathCommand,
    LineCommand? outgoingGhostPathCommand,
  ) {
    ingoingGhostPathCommand?.call(canvas);
    outgoingGhostPathCommand?.call(canvas);
  }

  void drawLineToolVertices(Canvas canvas, VertexStack vertexStack) {
    for (var vertex in vertexStack) {
      canvas.drawCircle(
        vertex.vertexCenter,
        Vertex.VERTEX_RADIUS,
        Vertex.getVertexPaint(),
      );
    }
  }

  Command redo() {
    final lastCommand = _redoStack.removeLast();
    _undoStack.add(lastCommand);
    return lastCommand;
  }

  void undo() {
    final lastCommand = _undoStack.removeLast();
    _redoStack.add(lastCommand);
  }

  List<Command> get redoStack => _redoStack;

  List<Command> get undoStack => _undoStack;

  ToolData getNextTool(ActionType actionType) {
    Command? command;
    switch (actionType) {
      case ActionType.UNDO:
        if (_undoStack.isEmpty) return ToolData.BRUSH;
        command = _undoStack.last;
        break;
      case ActionType.REDO:
        if (_redoStack.isEmpty) return ToolData.BRUSH;
        command = _redoStack.last;
        break;
    }

    ///TODO implement for all tools after implementing unique commands
    if (command.runtimeType == LineCommand) {
      return ToolData.LINE;
    } else if (command.runtimeType == SquareShapeCommand) {
      return ToolData.SHAPES;
    } else if (command.runtimeType == EllipseShapeCommand) {
      return ToolData.SHAPES;
    } else if (command.runtimeType == TextCommand) {
      return ToolData.TEXT;
    } else if (command.runtimeType == SprayCommand) {
      return ToolData.SPRAY;
    } else if (command.runtimeType == StarShapeCommand) {
      return ToolData.SHAPES;
    } else if (command.runtimeType == HeartShapeCommand) {
      return ToolData.SHAPES;
    } else if (command is PathCommand) {
      if (command.paint.maskFilter != null) {
        return ToolData.WATERCOLOR;
      } else {
        return ToolData.BRUSH;
      }
    } else {
      return ToolData.BRUSH;
    }
  }

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
