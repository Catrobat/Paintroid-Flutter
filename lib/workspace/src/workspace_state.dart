part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  const WorkspaceState({
    required this.isFullscreen,
    required this.isUserDrawing,
    this.loadedImage,
    required this.exportWidth,
    required this.exportHeight,
  }) : aspectRatio = exportWidth / exportHeight;

  final bool isFullscreen;
  final bool isUserDrawing;

  final int exportWidth;
  final int exportHeight;
  final double aspectRatio;
  final ui.Image? loadedImage;

  WorkspaceState copyWith({
    bool? isFullscreen,
    bool? isUserDrawing,
    int? exportWidth,
    int? exportHeight,
    ui.Image? loadedImage,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isUserDrawing: isUserDrawing ?? this.isUserDrawing,
      exportWidth: exportWidth ?? this.exportWidth,
      exportHeight: exportHeight ?? this.exportHeight,
      loadedImage: loadedImage ?? this.loadedImage,
    );
  }
}
