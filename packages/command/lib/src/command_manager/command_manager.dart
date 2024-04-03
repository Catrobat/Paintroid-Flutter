// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:command/command.dart';

abstract class CommandManager {
  Iterable<Command> get history;

  int get count;

  void addGraphicCommand(GraphicCommand command);

  void executeLastCommand(Canvas canvas);

  void executeAllCommands(Canvas canvas);

  void discardLastCommand();

  void clearHistory({Iterable<Command>? newCommands});
}
