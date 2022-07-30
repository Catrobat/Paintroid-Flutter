import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/command/command.dart';

part 'workspace_state.dart';

class WorkspaceStateNotifier extends StateNotifier<WorkspaceState> {
  WorkspaceStateNotifier(super.state, this._commandManager);

  final CommandManager _commandManager;

  bool get hasSavedLastWork =>
      state._commandCountWhenLastSaved == _commandManager.count;

  Future<T> performIOTask<T>(Future<T> Function() task) async {
    state = state.copyWith(isPerformingIOTask: true);
    final result = await task();
    state = state.copyWith(isPerformingIOTask: false);
    return result;
  }

  void updateLastSavedCommandCount() => state = state.copyWith(
        updatedLastSavedCommandCount: _commandManager.count,
      );

  void toggleFullscreen(bool isEnabled) => state = state.copyWith(
        isFullscreen: isEnabled,
      );

  void setBackgroundImage(Image image) => state = state.copyWith(
        backgroundImage: Option.some(image),
        exportSize: Size(image.width.toDouble(), image.height.toDouble()),
        updatedLastSavedCommandCount: _commandManager.count,
      );

  void clearBackgroundImageAndResetDimensions() => state = state.copyWith(
        backgroundImage: Option.none(),
        exportSize: WorkspaceState.initial.exportSize,
        updatedLastSavedCommandCount: _commandManager.count,
      );

  void resetWorkspace() => state = state.copyWith(
        backgroundImage: Option.none(),
        exportSize: WorkspaceState.initial.exportSize,
        updatedLastSavedCommandCount: _commandManager.count,
      );
}
