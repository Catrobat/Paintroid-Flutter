import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'canvas_state.dart';
part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier()
      : super(const WorkspaceState(
          canvasState: CanvasState(aspectRatio: 9 / 16, width: 1080),
        ));

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
          (ref) => WorkspaceStateNotifier());

  void toggleFullscreen(bool isEnabled) =>
      state = state.copyWith(isFullscreen: isEnabled);

  void toggleDrawingState(bool isDrawing) =>
      state = state.copyWith(isUserDrawing: isDrawing);

  void setCanvasWidth(double width) => state =
      state.copyWith(canvasState: state.canvasState.copyWith(width: width));
}
