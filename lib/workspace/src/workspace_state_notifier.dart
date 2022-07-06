import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier() : super(const WorkspaceState());

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
          (ref) => WorkspaceStateNotifier());

  void toggleFullscreen(bool isEnabled) =>
      state = state.copyWith(isFullscreen: isEnabled);

  void toggleDrawingState(bool isDrawing) =>
      state = state.copyWith(isUserDrawing: isDrawing);
}
