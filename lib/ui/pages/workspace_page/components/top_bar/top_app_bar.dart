// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/checkmark_clicked_state.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/ui/shared/checkmark_button.dart';
import 'package:paintroid/ui/shared/plus_button.dart';

class TopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

  List<Widget> getActions(Tool currentTool, WidgetRef ref) {
    List<Widget> actions = [
      if (currentTool is LineTool && currentTool.vertexStack.isNotEmpty) ...[
        PlusButton(onPressed: () {
          _onPlusPressed(currentTool);
        }),
        CheckMarkButton(onPressed: () {
          onCheckmarkPressed(currentTool, ref);
        }),
      ],
      const OverflowMenu(),
    ];
    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _onPlusPressed(Tool currentTool) {
    switch (currentTool.type) {
      case ToolType.LINE:
        (currentTool as LineTool).onPlus();
        break;
      default:
        break;
    }
  }

  void onCheckmarkPressed(Tool currentTool, WidgetRef ref) {
    switch (currentTool.type) {
      case ToolType.LINE:
        (currentTool as LineTool).onCheckMark();
        break;
      default:
        break;
    }
    ref.read(CheckMarkClickedState.provider.notifier).notify();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(toolBoxStateProvider).currentTool;

    ref.watch(CheckMarkClickedState.provider);

    List<Widget> actions = getActions(currentTool, ref);

    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: actions,
    );
  }
}
