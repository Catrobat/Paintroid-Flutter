import 'package:command/command.dart';
import 'package:command/command_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state, this._commandManager);

  final CommandManager _commandManager;

  bool get hasSavedLastWork =>
      state._commandCountWhenLastSaved == _commandManager.count;

  Future<T> performIOTask<T>(Future<T> Function() task) async {
    state = state.copyWith(isPerformingIOTask: true);
    final result = await task();
    state = state.copyWith(isPerformingIOTask: false);
    return result;
  }

  void updateLastSavedCommandCount() => state = state.copyWith(
        updatedLastSavedCommandCount: _commandManager.count,
      );

  void toggleFullscreen(bool isEnabled) => state = state.copyWith(
        isFullscreen: isEnabled,
      );
}
