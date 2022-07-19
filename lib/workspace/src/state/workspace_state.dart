part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  final bool isFullscreen;
  final Size exportSize;
  final double aspectRatio;
  final Image? loadedImage;

  static final initial = WorkspaceState(
    isFullscreen: false,
    exportSize: const Size(1080, 1920),
  );

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
    (ref) => WorkspaceStateNotifier(initial),
  );

  WorkspaceState({
    required this.isFullscreen,
    this.loadedImage,
    required this.exportSize,
  }) : aspectRatio = exportSize.width / exportSize.height;

  WorkspaceState copyWith({
    bool? isFullscreen,
    Size? exportSize,
    Image? loadedImage,
  }) {
    return WorkspaceState(
      isFullscreen: isFullscreen ?? this.isFullscreen,
      exportSize: exportSize ?? this.exportSize,
      loadedImage: loadedImage ?? this.loadedImage,
    );
  }
}
