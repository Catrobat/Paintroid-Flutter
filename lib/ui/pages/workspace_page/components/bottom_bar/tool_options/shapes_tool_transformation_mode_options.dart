import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/is_rotating_shape_provider.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ShapesToolTransformationModeOptions extends ConsumerWidget {
  const ShapesToolTransformationModeOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRotating = ref.watch(isRotatingShapeProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          spacing: 8,
          children: [
            CustomActionChip(
              hint: 'Rotate',
              chipBackgroundColor: isRotating ? Colors.blue : Colors.white,
              chipIcon: Icon(
                Icons.rotate_90_degrees_cw_outlined,
                color: PaintroidTheme.of(context).shadowColor,
              ),
              onPressed: () {
                ref.read(isRotatingShapeProvider.notifier).rotating();
              },
            ),
            CustomActionChip(
              hint: 'Translate and Scale',
              chipBackgroundColor: !isRotating ? Colors.blue : Colors.white,
              chipIcon: Icon(
                Icons.crop_free_rounded,
                color: PaintroidTheme.of(context).shadowColor,
              ),
              onPressed: () {
                ref.read(isRotatingShapeProvider.notifier).notRotating();
              },
            )
          ],
        )
      ],
    );
  }
}
