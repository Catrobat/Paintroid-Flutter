
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';

part 'command_manager_provider.g.dart';

@Riverpod(keepAlive: true)
class CommandManagerProvider extends _$CommandManagerProvider {
  @override
  CommandManager build() {
    return CommandManager(
      onUndo: () {
        ref.read(workspaceStateProvider.notifier).markUnsavedChanges();
      },
    );
  }
}
