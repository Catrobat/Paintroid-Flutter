part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  const WorkspaceState({
    this.isFullscreen = false,
    this.isUserDrawing = false,
  });

  final bool isFullscreen;
  final bool isUserDrawing;

  WorkspaceState copyWith({
    bool? isFullscreen,
    bool? isUserDrawing,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isUserDrawing: isUserDrawing ?? this.isUserDrawing,
    );
  }
}
