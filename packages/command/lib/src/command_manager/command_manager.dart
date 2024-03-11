import 'dart:ui';

import 'package:command/command.dart';
import 'package:tools/tools.dart';

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
}
