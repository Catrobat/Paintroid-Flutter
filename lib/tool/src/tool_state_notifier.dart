import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tool_state.dart';

class ToolStateNotifier extends StateNotifier<ToolState> {
  ToolStateNotifier(super.state);

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
}
