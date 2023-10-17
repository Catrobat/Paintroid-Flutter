import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toast/toast.dart';
import 'package:tools/tools.dart';

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

  void switchTool(ToolData data) {
    switch (data.type) {
      case ToolType.BRUSH:
        ref
            .read(brushToolStateProvider.notifier)
            .updateBlendMode(BlendMode.srcOver);
        state = state.copyWith(
          currentTool: ref.read(brushToolProvider),
          currentToolType: ToolType.BRUSH,
        );

        break;
      case ToolType.ERASER:
        ref
            .read(brushToolStateProvider.notifier)
            .updateBlendMode(BlendMode.clear);
        state = state.copyWith(
          currentTool: ref.read(eraserToolProvider),
          currentToolType: ToolType.ERASER,
        );
        break;
      default:
        ref
            .read(brushToolStateProvider.notifier)
            .updateBlendMode(BlendMode.srcOver);
        state = state.copyWith(
          currentTool: ref.read(brushToolProvider),
          currentToolType: ToolType.BRUSH,
        );
    }

    Toast.show(
      data.name,
      duration: Toast.lengthShort,
      gravity: Toast.bottom,
    );
  }

  @override
  ToolBoxStateData build() {
    return ToolBoxStateData(
      currentTool: ref.watch(brushToolProvider),
      currentToolType: ToolType.BRUSH,
      isDown: false,
    );
  }
}
