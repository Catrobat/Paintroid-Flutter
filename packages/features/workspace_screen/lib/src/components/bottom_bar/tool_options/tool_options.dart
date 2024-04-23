// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tools/tools.dart';

// Project imports:
import 'package:workspace_screen/workspace_screen.dart';

class ToolOptions extends ConsumerWidget {
  const ToolOptions({super.key});
  final maxOpacity = 1.0;
  final minOpacity = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool visible = ref.watch(toolOptionsVisibilityStateProvider);
    final currentToolType = ref.watch(
      toolBoxStateProvider.select((value) => value.currentToolType),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ToolOption(
          isIgnoring: !visible,
          opacity: visible ? maxOpacity : minOpacity,
          child: switch (currentToolType) {
            ToolType.BRUSH => const StrokeToolOptions(),
            ToolType.ERASER => const StrokeToolOptions(),
            _ => Container(),
          }),
    );
  }
}
