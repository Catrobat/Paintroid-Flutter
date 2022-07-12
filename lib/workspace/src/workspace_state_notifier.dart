import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state);

  static final provider =
      StateNotifierProvider<WorkspaceStateNotifier, WorkspaceState>(
    (ref) => WorkspaceStateNotifier(WorkspaceState.initial),
  );

  void toggleFullscreen(bool isEnabled) =>
      state = state.copyWith(isFullscreen: isEnabled);

  void toggleDrawingState(bool isDrawing) =>
      state = state.copyWith(isUserDrawing: isDrawing);

  void loadImage(ui.Image image) => state = state.copyWith(
        loadedImage: image,
        exportWidth: image.width,
        exportHeight: image.height,
      );
}
