import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/workspace/workspace.dart';

import 'tool_state.dart';

class ToolStateNotifier extends StateNotifier<ToolState> {
  ToolStateNotifier(super.state, this._canvasStateNotifier);

  final CanvasStateNotifier _canvasStateNotifier;

  void didTapDown(Offset position) {
    state.currentTool.onDown(position);
    state = state.copyWith(isDown: true);
  }

  void didDrag(Offset position) {
    state.currentTool.onDrag(position);
  }

  void didTapUp({Offset? position}) {
    state.currentTool.onUp(position);
    _canvasStateNotifier.updateLastCompiledImage();
    state = state.copyWith(isDown: false);
  }
}
