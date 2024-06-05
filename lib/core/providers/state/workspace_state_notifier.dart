// Flutter imports:

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state, this._commandManager) {
    _hasUnsavedChanges =
        state.commandCountWhenLastSaved != _commandManager.count;
  }

  final CommandManager _commandManager;
  bool _hasUnsavedChanges = false;

  bool get hasUnsavedChanges => _hasUnsavedChanges;

  void markUnsavedChanges() {
    _hasUnsavedChanges = true;
  }

  void updateLastSavedCommandCount() {
    _hasUnsavedChanges = false;
    state = state.copyWith(commandCountWhenLastSaved: _commandManager.count);
  }

  bool get hasSavedLastWork =>
      state.commandCountWhenLastSaved == _commandManager.count;

  Future<T> performIOTask<T>(Future<T> Function() task) async {
    state = state.copyWith(isPerformingIOTask: true);
    final result = await task();
    state = state.copyWith(isPerformingIOTask: false);
    return result;
  }

  void toggleFullscreen(bool isEnabled) => state = state.copyWith(
        isFullscreen: isEnabled,
      );
}
