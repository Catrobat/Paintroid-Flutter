import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/workspace/workspace.dart';

import 'brush_tool.dart';
import 'tool.dart';
import 'tool_state_notifier.dart';

@immutable
class ToolState {
  final Tool currentTool;
  final bool isDown;
  final bool areOptionsVisible;

  static final provider = StateNotifierProvider<ToolStateNotifier, ToolState>(
    (ref) {
      final notifier = ToolStateNotifier(
        ToolState(
          currentTool: ref.watch(BrushTool.provider),
          isDown: false,
          areOptionsVisible: true,
        ),
      );
      ref.listen<bool>(
        WorkspaceState.provider.select((value) => value.isFullscreen),
        (_, isFullscreen) {
          if (isFullscreen) {
            notifier.toggleOptionsVisibility(false);
          }
        },
      );
      return notifier;
    },
  );

  const ToolState({
    required this.currentTool,
    required this.isDown,
    required this.areOptionsVisible,
  });

  ToolState copyWith({
    Tool? currentTool,
    bool? isDown,
    bool? areOptionsVisible,
  }) {
    return ToolState(
      currentTool: currentTool ?? this.currentTool,
      isDown: isDown ?? this.isDown,
      areOptionsVisible: areOptionsVisible ?? this.areOptionsVisible,
    );
  }
}
