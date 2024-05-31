// Package imports:

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/sync_command_manager.dart';

part 'command_manager_provider.g.dart';

@Riverpod(keepAlive: true)
CommandManager commandManager(CommandManagerRef ref) {
  return SyncCommandManager(commands: []);
}
