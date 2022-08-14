import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/brush_tool_options.dart';

class ToolOptions extends ConsumerWidget {
  const ToolOptions({Key? key}) : super(key: key);

  static const toggleAnimDuration = Duration(milliseconds: 200);
  static const toggleAnimCurve = Curves.easeInOutExpo;

  Widget? _optionsFor(Tool tool) {
    if (tool is BrushTool) {
      return const BrushToolOptions();
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(ToolState.provider).currentTool;
    return _optionsFor(currentTool) ?? Container();
  }
}
