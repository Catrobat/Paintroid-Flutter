import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state);

  void toggleFullscreen(bool isEnabled) =>
      state = state.copyWith(isFullscreen: isEnabled);

  void loadImage(Image image) => state = state.copyWith(
        loadedImage: image,
        exportSize: Size(image.width.toDouble(), image.height.toDouble()),
      );

  void clearLoadedImage() => state = state.copyWith(
        loadedImage: null,
        exportSize: WorkspaceState.initial.exportSize,
      );
}
