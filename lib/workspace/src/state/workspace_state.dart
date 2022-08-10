part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  final bool isFullscreen;
  final bool isPerformingIOTask;
  final int _commandCountWhenLastSaved;

  static const initial = WorkspaceState();

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
    (ref) => WorkspaceStateNotifier(
      initial,
      ref.watch(CommandManager.provider),
    ),
  );

  const WorkspaceState({
    this.isFullscreen = false,
    this.isPerformingIOTask = false,
    int commandCountWhenLastSaved = 0,
  }) : _commandCountWhenLastSaved = commandCountWhenLastSaved;

  WorkspaceState copyWith({
    bool? isFullscreen,
    bool? isPerformingIOTask,
    int? updatedLastSavedCommandCount,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isPerformingIOTask: isPerformingIOTask ?? this.isPerformingIOTask,
      commandCountWhenLastSaved:
          updatedLastSavedCommandCount ?? _commandCountWhenLastSaved,
    );
  }
}
