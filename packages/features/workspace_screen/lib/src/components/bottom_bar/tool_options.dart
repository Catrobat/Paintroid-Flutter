import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

class ToolOptions extends ConsumerWidget {
  const ToolOptions({super.key});
  final maxOpacity = 1.0;
  final minOpacity = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool visible = ref.watch(toolOptionsVisibilityStateProvider);

    var currentToolType = ref.watch(
      toolBoxStateProvider.select((value) => value.currentToolType),
    );

    List<Widget> toolSpecificOptions =
        ToolOptionsConfig().getToolSpecificOptions(currentToolType);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          for (Widget option in toolSpecificOptions)
            if (option is Spacer)
              const Spacer()
            else
              ToolOption(
                isIgnoring: !visible,
                opacity: visible ? maxOpacity : minOpacity,
                child: option,
              ),
        ],
      ),
    );
  }
}
