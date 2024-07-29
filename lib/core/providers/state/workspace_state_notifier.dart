import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/providers/state/workspace_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_state_notifier.g.dart';

@Riverpod(keepAlive: true)
class WorkspaceStateProvider extends _$WorkspaceStateProvider {
  @override
  WorkspaceState build() {
    return WorkspaceState(
      isFullscreen: false,
      isPerformingIOTask: false,
      hasUnsavedChanges: ref.watch(commandManagerProvider).undoStack.isNotEmpty,
      commandCountWhenLastSaved: 0,
    );
  }

  bool get hasUnsavedChanges => state.hasUnsavedChanges;

  bool get hasSavedLastWork =>
      state.commandCountWhenLastSaved ==
      ref.read(commandManagerProvider).undoStack.length;

  void markUnsavedChanges() {
    state = state.copyWith(hasUnsavedChanges: true);
  }

  void updateLastSavedCommandCount() {
    state = state.copyWith(hasUnsavedChanges: false);
    state = state.copyWith(
      commandCountWhenLastSaved:
          ref.read(commandManagerProvider).undoStack.length,
    );
  }

  Future<T> performIOTask<T>(Future<T> Function() task) async {
    state = state.copyWith(isPerformingIOTask: true);
    final result = await task();
    state = state.copyWith(isPerformingIOTask: false);
    return result;
  }

  void toggleFullscreen(bool isEnabled) {
    state = state.copyWith(isFullscreen: isEnabled);
  }
}
