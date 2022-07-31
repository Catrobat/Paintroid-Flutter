part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  final bool isFullscreen;
  final bool isPerformingIOTask;
  final Size exportSize;
  final Image? backgroundImage;
  final int _commandCountWhenLastSaved;

  static const initial = WorkspaceState(exportSize: Size(1080, 1920));

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
    (ref) => WorkspaceStateNotifier(
      initial,
      ref.watch(CommandManager.provider),
    ),
  );

  const WorkspaceState({
    required this.exportSize,
    this.isFullscreen = false,
    this.isPerformingIOTask = false,
    this.backgroundImage,
    int commandCountWhenLastSaved = 0,
  }) : _commandCountWhenLastSaved = commandCountWhenLastSaved;

  WorkspaceState copyWith({
    bool? isFullscreen,
    bool? isPerformingIOTask,
    Size? exportSize,
    Option<Image>? backgroundImage,
    int? updatedLastSavedCommandCount,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isPerformingIOTask: isPerformingIOTask ?? this.isPerformingIOTask,
      exportSize: exportSize ?? this.exportSize,
      backgroundImage: backgroundImage != null
          ? backgroundImage.toNullable()
          : this.backgroundImage,
      commandCountWhenLastSaved:
          updatedLastSavedCommandCount ?? _commandCountWhenLastSaved,
    );
  }
}
