// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:paintroid/core/providers/object/tools/text_tool_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toast/toast.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/brush_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/eraser_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/hand_tool_provider.dart';
import 'package:paintroid/core/providers/object/tools/line_tool_provider.dart';
import 'package:paintroid/core/providers/state/tools/brush/brush_tool_state_provider.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_data.dart';
import 'package:paintroid/core/tools/tool_data.dart';

part 'toolbox_state_provider.g.dart';

@riverpod
class ToolBoxStateProvider extends _$ToolBoxStateProvider {
  void didTapDown(Offset position) {
    ref.read(commandManagerProvider).clearRedoStack();
    state.currentTool.onDown(position);
    state = state.copyWith(isDown: true);
  }

  void didDrag(Offset position) {
    state.currentTool.onDrag(position);
  }

  void didTapUp(Offset position) {
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
      case ToolType.HAND:
        state = state.copyWith(
          currentTool: ref.read(handToolProvider),
          currentToolType: ToolType.HAND,
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
      case ToolType.LINE:
        ref
            .read(brushToolStateProvider.notifier)
            .updateBlendMode(BlendMode.srcOver);
        state = state.copyWith(
          currentTool: ref.read(lineToolProvider),
          currentToolType: ToolType.LINE,
        );
        break;
      case ToolType.TEXT:
        ref
            .read(brushToolStateProvider.notifier)
            .updateBlendMode(BlendMode.srcOver);
        state = state.copyWith(
          currentTool: ref.read(textToolProvider),
          currentToolType: ToolType.TEXT,
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
