import 'dart:ui';

import 'package:command/command.dart';
import 'package:tools/tools.dart';

class SyncCommandManager implements CommandManager {
  SyncCommandManager({required List<Command> commands}) : _history = commands;

  final List<Command> _history;

  @override
  Iterable<Command> get history => List.unmodifiable(_history);

  @override
  int get count => _history.length;

  @override
  void addGraphicCommand(GraphicCommand command) {
    _history.add(command);
  }

  @override
  void executeLastCommand(Canvas canvas) {
    if (_history.isEmpty) return;
    final lastCommand = _history.last;
    if (lastCommand is GraphicCommand) {
      lastCommand.call(canvas);
    }
  }

  @override
  void executeAllCommands(Canvas canvas) {
    for (final command in _history) {
      if (command is GraphicCommand) {
        command.call(canvas);
      }
    }
  }

  @override
  void discardLastCommand() {
    if (_history.isNotEmpty) _history.removeLast();
  }

  @override
  void clearHistory({Iterable<Command>? newCommands}) {
    _history.clear();
    if (newCommands != null) {
      _history.addAll(newCommands);
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
}
