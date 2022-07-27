part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  final bool isFullscreen;
  final Size exportSize;
  final Image? backgroundImage;
  final int _commandCountWhenLastSaved;

  static const initial = WorkspaceState(
    isFullscreen: false,
    exportSize: Size(1080, 1920),
  );

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
    (ref) => WorkspaceStateNotifier(
      initial,
      ref.watch(CommandManager.provider),
    ),
  );

  const WorkspaceState({
    required this.isFullscreen,
    this.backgroundImage,
    int commandCountWhenLastSaved = 0,
    required this.exportSize,
  }) : _commandCountWhenLastSaved = commandCountWhenLastSaved;

  WorkspaceState copyWith({
    bool? isFullscreen,
    Size? exportSize,
    Option<Image>? backgroundImage,
    int? updatedLastSavedCommandCount,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      exportSize: exportSize ?? this.exportSize,
      backgroundImage: backgroundImage != null
          ? backgroundImage.toNullable()
          : this.backgroundImage,
      commandCountWhenLastSaved:
          updatedLastSavedCommandCount ?? _commandCountWhenLastSaved,
    );
  }
}
