import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/src/command.dart';
import 'package:paintroid/command/src/graphic_command.dart';
import 'package:paintroid/command/src/implementation/manager/sync_command_manager.dart';

abstract class CommandManager {
  static final provider = Provider<CommandManager>(
    (ref) => SyncCommandManager(commands: []),
  );

  Iterable<Command> get history;

  int get count;

  void addGraphicCommand(GraphicCommand command);

  void executeLastCommand(Canvas canvas);

  void executeAllCommands(Canvas canvas);

  void discardLastCommand();

  void clearHistory({Iterable<Command>? newCommands});
}
