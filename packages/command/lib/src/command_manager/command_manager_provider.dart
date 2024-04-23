// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:command/command.dart';

part 'command_manager_provider.g.dart';

@Riverpod(keepAlive: true)
CommandManager commandManager(CommandManagerRef ref) {
  return SyncCommandManager(commands: []);
}
