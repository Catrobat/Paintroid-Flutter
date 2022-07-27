import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/nullable.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state, this._commandManager);

  final CommandManager _commandManager;

  bool get hasSavedLastWork =>
      state._commandCountWhenLastSaved == _commandManager.count;

  void updateLastSavedCommandCount() => state = state.copyWith(
        updatedLastSavedCommandCount: _commandManager.count,
      );

  void toggleFullscreen(bool isEnabled) => state = state.copyWith(
        isFullscreen: isEnabled,
      );

  void setBackgroundImage(Image image) => state = state.copyWith(
        backgroundImage: Nullable(image),
        exportSize: Size(image.width.toDouble(), image.height.toDouble()),
      );

  void clearBackgroundImageAndResetDimensions() => state = state.copyWith(
        backgroundImage: const Nullable(null),
        exportSize: WorkspaceState.initial.exportSize,
      );
}
