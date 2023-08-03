import 'dart:ui';

import 'package:paintroid/tool/src/brush_tool/brush_tool_provider.dart';
import 'package:paintroid/tool/src/toolbox/toolbox_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toolbox_state_provider.g.dart';

@riverpod
class ToolBoxState extends _$ToolBoxState {
  void didTapDown(Offset position) {
    state.currentTool.onDown(position);
    state = state.copyWith(isDown: true);
  }

  void didDrag(Offset position) {
    state.currentTool.onDrag(position);
  }

  void didTapUp({Offset? position}) {
    state.currentTool.onUp(position);
    state = state.copyWith(isDown: false);
  }

  void didSwitchToZooming() {
    state.currentTool.onCancel();
    state = state.copyWith(isDown: false);
  }

  @override
  ToolBoxStateData build() {
    return ToolBoxStateData(
      currentTool: ref.watch(brushToolProvider),
      isDown: false,
    );
  }
}
