import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

class TopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(toolBoxStateProvider).currentTool;

    List<Widget> actions = [
      if (currentTool.type == ToolType.LINE) ...[
        PlusButton(onPressed: () {
          _onPlusPressed(currentTool);
        }),
        CheckMarkButton(onPressed: () {
          onCheckmarkPressed(currentTool);
        }),
      ],
      const OverflowMenu(),
    ];

    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: actions,
    );
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

  void onCheckmarkPressed(Tool currentTool) {
    switch (currentTool.type) {
      case ToolType.LINE:
        (currentTool as LineTool).onCheckMark();
        break;
      default:
        break;
    }
  }
}

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: onPressed,
    );
  }
}

class CheckMarkButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CheckMarkButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: onPressed,
    );
  }
}
