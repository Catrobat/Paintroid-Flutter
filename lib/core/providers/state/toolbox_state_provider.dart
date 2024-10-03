import 'dart:ui';

import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/object/tools/brush_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/eraser_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/hand_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/line_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/shapes_tool_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/spray_tool_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_data.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toolbox_state_provider.g.dart';

@riverpod
class ToolBoxStateProvider extends _$ToolBoxStateProvider {
  @override
  ToolBoxStateData build() {
    return ToolBoxStateData(
      currentTool: ref.read(brushToolProvider),
      isDown: false,
    );
  }

  void didTapDown(Offset position) {
    if (state.currentTool.type != ToolType.SHAPES) {
      ref.read(commandManagerProvider).clearRedoStack();
    }
    state.currentTool.onDown(position, ref.read(paintProvider));
    state = state.copyWith(isDown: true);
  }

  void didDrag(Offset position) =>
      state.currentTool.onDrag(position, ref.read(paintProvider));

  void didTapUp(Offset position) {
    state.currentTool.onUp(position, ref.read(paintProvider));
    state = state.copyWith(isDown: false);
  }

  void didSwitchToZooming() {
    state.currentTool.onCancel();
    state = state.copyWith(isDown: false);
  }

  void switchTool(ToolData data) {
    switch (data.type) {
      case ToolType.BRUSH:
        state = state.copyWith(currentTool: ref.read(brushToolProvider));
        break;
      case ToolType.HAND:
        state = state.copyWith(currentTool: ref.read(handToolProvider));
        break;
      case ToolType.ERASER:
        state = state.copyWith(currentTool: ref.read(eraserToolProvider));
        break;
      case ToolType.LINE:
        state = state.copyWith(currentTool: ref.read(lineToolProvider));
        break;
      case ToolType.SHAPES:
        state = state.copyWith(currentTool: ref.read(shapesToolProvider));
        ref.read(canvasPainterProvider.notifier).repaint();
        break;
      case ToolType.SPRAY:
        state = state.copyWith(currentTool: ref.read(sprayToolProvider));
        ref.read(paintProvider.notifier).updateStrokeWidth(10);
        break;
      default:
        state = state.copyWith(currentTool: ref.read(brushToolProvider));
        break;
    }
    ref.read(paintProvider.notifier).updateBlendModeByToolType(data.type);
    ToastUtils.showShortToast(message: data.name);
  }
}
