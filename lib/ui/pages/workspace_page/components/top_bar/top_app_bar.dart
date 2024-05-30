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

  List<Widget> getActions(Tool currentTool, WidgetRef ref) {
    final commandManager = ref.read(commandManagerProvider);

    List<Widget> actions = [
      ActionButton(
        onPressed: commandManager.undoStack.isNotEmpty
            ? () async {
                currentTool.undo();
                await ref
                    .read(canvasStateProvider.notifier)
                    .resetCanvasWithExistingCommands();
                ref.read(TopBarActionClickedState.provider.notifier).notify();
              }
            : null,
        icon: TopBarActionData.UNDO.iconData,
        valueKey: TopBarActionData.UNDO.name,
      ),
      ActionButton(
        onPressed: commandManager.redoStack.isNotEmpty
            ? () async {
                currentTool.redo();
                await ref
                    .read(canvasStateProvider.notifier)
                    .resetCanvasWithExistingCommands();
                ref.read(TopBarActionClickedState.provider.notifier).notify();
              }
            : null,
        icon: TopBarActionData.REDO.iconData,
        valueKey: TopBarActionData.REDO.name,
      ),
      if (currentTool is LineTool && currentTool.vertexStack.isNotEmpty) ...[
        ActionButton(
          onPressed: () {
            currentTool.onPlus();
          },
          icon: TopBarActionData.PLUS.iconData,
          valueKey: TopBarActionData.PLUS.name,
        ),
        ActionButton(
          onPressed: () {
            currentTool.onCheckmark();
            ref.read(TopBarActionClickedState.provider.notifier).notify();
          },
          icon: TopBarActionData.CHECKMARK.iconData,
          valueKey: TopBarActionData.CHECKMARK.name,
        ),
      ],
      const OverflowMenu(),
    ];
    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(toolBoxStateProvider).currentTool;

    ref.watch(TopBarActionClickedState.provider);

    List<Widget> actions = getActions(currentTool, ref);

    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: actions,
    );
  }
}
