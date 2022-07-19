import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'graphic_command.dart';
import 'implementation/manager/sync_command_manager.dart';

abstract class CommandManager {
  static final provider = Provider<CommandManager>(
    (ref) => SyncCommandManager(commands: []),
  );

  void addGraphicCommand(GraphicCommand command);

  void executeLastCommand(Canvas canvas);

  void executeAllCommands(Canvas canvas);
}
