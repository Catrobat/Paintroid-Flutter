import 'dart:ui';

import 'package:paintroid/core/providers/object/tools/text_tool_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/brush_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/eraser_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/hand_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/line_tool_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_data.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';

part 'toolbox_state_provider.g.dart';

@riverpod
class ToolBoxStateProvider extends _$ToolBoxStateProvider {
  @override
  ToolBoxStateData build() {
    return ToolBoxStateData(
      currentTool: ref.watch(brushToolProvider),
      currentToolType: ToolType.BRUSH,
      isDown: false,
    );
  }

  void didTapDown(Offset position) {
    ref.read(commandManagerProvider).clearRedoStack();
    state.currentTool.onDown(position, ref.read(paintProvider));
    state = state.copyWith(isDown: true);
  }

  void didDrag(Offset position) {
    state.currentTool.onDrag(position, ref.read(paintProvider));
  }

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
        state = state.copyWith(
          currentTool: ref.read(brushToolProvider),
          currentToolType: ToolType.BRUSH,
        );
        break;
      case ToolType.HAND:
        state = state.copyWith(
          currentTool: ref.read(handToolProvider),
          currentToolType: ToolType.HAND,
        );
        break;
      case ToolType.ERASER:
        state = state.copyWith(
          currentTool: ref.read(eraserToolProvider),
          currentToolType: ToolType.ERASER,
        );
        break;
      case ToolType.LINE:
        state = state.copyWith(
          currentTool: ref.read(lineToolProvider),
          currentToolType: ToolType.LINE,
        );
        break;
      case ToolType.TEXT:
        state = state.copyWith(
          currentTool: ref.read(textToolProvider),
          currentToolType: ToolType.TEXT,
        );
        break;
      default:
        state = state.copyWith(
          currentTool: ref.read(brushToolProvider),
          currentToolType: ToolType.BRUSH,
        );
        break;
    }

    ref.read(paintProvider.notifier).updateBlendModeByToolType(data.type);

    ToastUtils.showShortToast(message: data.name);
  }
}
