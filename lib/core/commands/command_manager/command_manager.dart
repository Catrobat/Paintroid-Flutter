// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/tools/line_tool/line_tool_vertex.dart';
import 'package:paintroid/core/tools/line_tool/vertex_stack.dart';

class CommandManager implements ICommandManager {
  CommandManager({required List<Command> commands}) : _undoStack = commands;

  final List<Command> _undoStack;
  final List<Command> _redoStack = [];

  @override
  Iterable<Command> get history => List.unmodifiable(_undoStack);

  @override
  int get count => _undoStack.length;

  @override
  void addGraphicCommand(GraphicCommand command) {
    _undoStack.add(command);
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
  void clearHistory({Iterable<Command>? newCommands}) {
    _undoStack.clear();
    if (newCommands != null) {
      _undoStack.addAll(newCommands);
    }
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
  void redo() {
    if (_redoStack.isNotEmpty) {
      final lastCommand = _redoStack.removeLast();
      _undoStack.add(lastCommand);
    }
  }

  @override
  void undo() {
    if (_undoStack.isNotEmpty) {
      final lastCommand = _undoStack.removeLast();
      _redoStack.add(lastCommand);
    }
  }
}
