// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/tools/line_tool/vertex_stack.dart';

abstract class CommandManager {
  Iterable<Command> get history;

  int get count;

  void addGraphicCommand(GraphicCommand command);

  void executeLastCommand(Canvas canvas);

  void executeAllCommands(Canvas canvas);

  void discardLastCommand();

  void clearHistory({Iterable<Command>? newCommands});

  void drawLineToolGhostPaths(
    Canvas canvas,
    LineCommand? ingoingGhostPathCommand,
    LineCommand? outgoingGhostPathCommand,
  );

  void drawLineToolVertices(Canvas canvas, VertexStack vertexStack);

  void undo();

  void redo();
}
