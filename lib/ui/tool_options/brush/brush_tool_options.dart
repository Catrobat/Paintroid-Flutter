import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/tool_options/brush/stroke_cap_choice_chip.dart';
import 'package:paintroid/ui/tool_options/brush/stroke_width_slider.dart';
import 'package:paintroid/ui/tool_options/brush/stroke_width_visualizer.dart';

import '../tool_options.dart';

class BrushToolOptions extends ConsumerWidget {
  const BrushToolOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsVisible = ref.watch(
      ToolState.provider.select((state) => state.areOptionsVisible),
    );
    return Stack(
      children: [
        AnimatedPositioned(
          top: optionsVisible ? 0 : -50,
          left: 0,
          right: 0,
          duration: ToolOptions.toggleAnimDuration,
          curve: ToolOptions.toggleAnimCurve,
          child: const StrokeWidthSlider(),
        ),
        AnimatedPositioned(
          bottom: optionsVisible ? 0 : -50,
          left: 0,
          right: 0,
          duration: ToolOptions.toggleAnimDuration,
          curve: ToolOptions.toggleAnimCurve,
          child: _strokeCapAndWidthVisualizer,
        ),
      ],
    );
  }

  Widget get _strokeCapAndWidthVisualizer {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 8,
            children: const [
              StrokeCapChoiceChip(icon: Icons.circle, cap: StrokeCap.round),
              StrokeCapChoiceChip(icon: Icons.square, cap: StrokeCap.square),
            ],
          ),
          const StrokeWidthVisualizer(),
        ],
      ),
    );
  }
}
