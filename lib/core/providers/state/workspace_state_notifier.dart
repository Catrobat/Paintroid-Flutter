// Flutter imports:

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state, this._commandManager) {
    _hasUnsavedChanges =
        state.commandCountWhenLastSaved != _commandManager.undoStack.length;
  }

  final ICommandManager _commandManager;
  bool _hasUnsavedChanges = false;

  bool get hasUnsavedChanges => _hasUnsavedChanges;

  void markUnsavedChanges() {
    _hasUnsavedChanges = true;
  }

  void updateLastSavedCommandCount() {
    _hasUnsavedChanges = false;
    state = state.copyWith(
        commandCountWhenLastSaved: _commandManager.undoStack.length);
  }

  bool get hasSavedLastWork =>
      state.commandCountWhenLastSaved == _commandManager.undoStack.length;

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
