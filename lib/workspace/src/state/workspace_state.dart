part of 'workspace_state_notifier.dart';

@immutable
class WorkspaceState {
  final bool isFullscreen;
  final Size exportSize;
  final Image? loadedImage;

  static const initial = WorkspaceState(
    isFullscreen: false,
    exportSize: Size(1080, 1920),
  );

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
    (ref) => WorkspaceStateNotifier(initial),
  );

  const WorkspaceState({
    required this.isFullscreen,
    this.loadedImage,
    required this.exportSize,
  });

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
