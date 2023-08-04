import 'dart:ui';

import 'package:paintroid/command/src/command.dart';
import 'package:paintroid/command/src/graphic_command.dart';

abstract class CommandManager {
  Iterable<Command> get history;

  int get count;

  void addGraphicCommand(GraphicCommand command);

  void executeLastCommand(Canvas canvas);

  void executeAllCommands(Canvas canvas);

  void discardLastCommand();

  void clearHistory({Iterable<Command>? newCommands});
}
