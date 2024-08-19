import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/app_bar_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
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

  void Function()? _onUndo(
    Tool currentTool,
    CommandManager commandManager,
    WidgetRef ref,
  ) {
    if (commandManager.undoStack.isNotEmpty) {
      return () async {
        _switchTool(commandManager, currentTool, ActionType.UNDO, ref);
        ref.read(toolBoxStateProvider).currentTool.onUndo();
        await ref
            .read(canvasStateProvider.notifier)
            .resetCanvasWithExistingCommands();
        ref.read(appBarProvider.notifier).update();
      };
    }
    return null;
  }

  void Function()? _onRedo(
    Tool currentTool,
    CommandManager commandManager,
    WidgetRef ref,
  ) {
    if (commandManager.redoStack.isNotEmpty) {
      return () async {
        _switchTool(commandManager, currentTool, ActionType.REDO, ref);
        ref.read(toolBoxStateProvider).currentTool.onRedo();
        await ref
            .read(canvasStateProvider.notifier)
            .resetCanvasWithExistingCommands();
        ref.read(appBarProvider.notifier).update();
      };
    }
    return null;
  }

  void _switchTool(
    CommandManager commandManager,
    Tool currentTool,
    ActionType actionType,
    WidgetRef ref,
  ) {
    var nextTool = commandManager.getNextTool(actionType);
    if (currentTool.type == nextTool.type) return;
    ref.read(toolBoxStateProvider.notifier).switchTool(nextTool);
  }

  void Function()? _onCheckmark(Tool currentTool, WidgetRef ref) {
    final isLineTool =
        currentTool is LineTool && currentTool.vertexStack.isNotEmpty;
    final isShapeTool = currentTool.type == ToolType.SHAPES;
    if (isLineTool || isShapeTool) {
      return () {
        currentTool.onCheckmark(ref.read(paintProvider));
        ref.read(appBarProvider.notifier).update();
        ref
            .read(canvasStateProvider.notifier)
            .resetCanvasWithExistingCommands();
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
    ref.watch(appBarProvider);

    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: [
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
        ActionButton(
          onPressed: _onUndo(currentTool, commandManager, ref),
          icon: TopBarActionData.UNDO.iconData,
          valueKey: TopBarActionData.UNDO.name,
        ),
        ActionButton(
          onPressed: _onRedo(currentTool, commandManager, ref),
          icon: TopBarActionData.REDO.iconData,
          valueKey: TopBarActionData.REDO.name,
        ),
        const OverflowMenu(),
      ],
    );
  }
}
