import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/shapes_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ShapesToolTransformationModeOptions extends ConsumerWidget {
  const ShapesToolTransformationModeOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(toolBoxStateProvider).currentTool;
    final shapeToolSelected = currentTool.type == ToolType.SHAPES;
    final shapesToolOptionsState = ref.watch(shapesToolOptionsStateProvider);
    return !shapeToolSelected
        ? const SizedBox.shrink()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  CustomActionChip(
                    hint: 'Rotate Only',
                    chipBackgroundColor: shapesToolOptionsState.isRotating
                        ? PaintroidTheme.of(context).primaryColor
                        : Colors.white,
                    chipIcon: Icon(
                      Icons.rotate_90_degrees_cw_outlined,
                      color: PaintroidTheme.of(context).shadowColor,
                    ),
                    onPressed: () => ref
                        .read(shapesToolOptionsStateProvider.notifier)
                        .setIsRotating(isRotating: true),
                  ),
                  CustomActionChip(
                    hint: 'Transform',
                    chipBackgroundColor: !shapesToolOptionsState.isRotating
                        ? PaintroidTheme.of(context).primaryColor
                        : Colors.white,
                    chipIcon: Icon(
                      Icons.crop_free_rounded,
                      color: PaintroidTheme.of(context).shadowColor,
                    ),
                    onPressed: () => ref
                        .read(shapesToolOptionsStateProvider.notifier)
                        .setIsRotating(isRotating: false),
                  )
                ],
              )
            ],
          );
  }
}
