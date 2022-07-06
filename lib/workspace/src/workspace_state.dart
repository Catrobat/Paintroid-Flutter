part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  const WorkspaceState({
    this.isFullscreen = false,
    this.isUserDrawing = false,
    required this.canvasState
  });

  final bool isFullscreen;
  final bool isUserDrawing;
  final CanvasState canvasState;

  WorkspaceState copyWith({
    bool? isFullscreen,
    bool? isUserDrawing,
    CanvasState? canvasState,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isUserDrawing: isUserDrawing ?? this.isUserDrawing,
      canvasState: canvasState ?? this.canvasState,
    );
  }
}
