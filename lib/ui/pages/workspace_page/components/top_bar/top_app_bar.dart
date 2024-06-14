// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/providers/state/topbar_action_clicked_state.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/ui/shared/action_button.dart';
import 'package:paintroid/ui/utils/top_bar_action_data.dart';

class TopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _onUndo(Tool currentTool, WidgetRef ref) async {
    currentTool.undo();
    await ref
        .read(canvasStateProvider.notifier)
        .resetCanvasWithExistingCommands();
    ref.read(TopBarActionClickedState.provider.notifier).notify();
  }

  Future<void> _onRedo(Tool currentTool, WidgetRef ref) async {
    currentTool.redo();
    await ref
        .read(canvasStateProvider.notifier)
        .resetCanvasWithExistingCommands();
    ref.read(TopBarActionClickedState.provider.notifier).notify();
  }

  void Function()? _onCheckmark(Tool currentTool, WidgetRef ref) {
    if (currentTool is LineTool && currentTool.vertexStack.isNotEmpty) {
      return () {
        currentTool.onCheckmark();
      };
    }
    return null;
  }

  void Function()? _onPlus(Tool currentTool) {
    if (currentTool is LineTool && currentTool.vertexStack.isNotEmpty) {
      return () {
        currentTool.onPlus();
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(toolBoxStateProvider).currentTool;
    final commandManager = ref.read(commandManagerProvider);
    ref.watch(TopBarActionClickedState.provider);

    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: [
        if (currentTool.hasUndoRedoFunctionality) ...[
          ActionButton(
            onPressed: commandManager.undoStack.isNotEmpty
                ? () async => await _onUndo(currentTool, ref)
                : null,
            icon: TopBarActionData.UNDO.iconData,
            valueKey: TopBarActionData.UNDO.name,
          ),
          ActionButton(
            onPressed: commandManager.redoStack.isNotEmpty
                ? () async => await _onRedo(currentTool, ref)
                : null,
            icon: TopBarActionData.REDO.iconData,
            valueKey: TopBarActionData.REDO.name,
          ),
        ],
        if (currentTool.hasAddFunctionality)
          ActionButton(
            onPressed: _onPlus(currentTool),
            icon: TopBarActionData.PLUS.iconData,
            valueKey: TopBarActionData.PLUS.name,
          ),
        if (currentTool.hasFinalizeFunctionality)
          ActionButton(
            onPressed: _onCheckmark(currentTool, ref),
            icon: TopBarActionData.CHECKMARK.iconData,
            valueKey: TopBarActionData.CHECKMARK.name,
          ),
        const OverflowMenu(),
      ],
    );
  }
}
