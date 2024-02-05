import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/src/states/checkmark_clicked_state.dart';
import 'package:workspace_screen/workspace_screen.dart';

class TopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({Key? key, required this.title}) : super(key: key);

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
