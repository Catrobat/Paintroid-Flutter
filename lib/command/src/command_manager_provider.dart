import 'package:paintroid/command/src/command_manager.dart';
import 'package:paintroid/command/src/implementation/manager/sync_command_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_manager_provider.g.dart';

@Riverpod(keepAlive: true)
CommandManager commandManager(CommandManagerRef ref) {
  return SyncCommandManager(commands: []);
}
