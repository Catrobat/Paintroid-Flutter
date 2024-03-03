part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  final bool isFullscreen;
  final bool isPerformingIOTask;
  final int commandCountWhenLastSaved;
  static const initial = WorkspaceState();

  static final provider =
  StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
        (ref) => WorkspaceStateNotifier(
      initial,
      ref.watch(commandManagerProvider),
    ),
  );


  const WorkspaceState({
    this.isFullscreen = false,
    this.isPerformingIOTask = false,
    this.commandCountWhenLastSaved = 0,
  });

  WorkspaceState copyWith({
    bool? isFullscreen,
    bool? isPerformingIOTask,
    int? commandCountWhenLastSaved,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isPerformingIOTask: isPerformingIOTask ?? this.isPerformingIOTask,
      commandCountWhenLastSaved: commandCountWhenLastSaved ?? this.commandCountWhenLastSaved,
    );
  }
}
