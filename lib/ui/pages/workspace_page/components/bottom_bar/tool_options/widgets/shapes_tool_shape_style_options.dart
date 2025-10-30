import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/providers/object/shapes_tool_options_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ShapesToolShapeStyleOptions extends ConsumerWidget {
  const ShapesToolShapeStyleOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentShapeStyle =
        ref.watch(shapesToolOptionsStateProvider).shapeStyle;
    final shapeStyleItems = [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CustomActionChip(
          key: const ValueKey(WidgetIdentifier.outlineStyleChip),
          hint: 'Outline',
          chipIcon: Icon(
            Icons.square_outlined,
            color: PaintroidTheme.of(context).shadowColor,
          ),
          chipBackgroundColor: currentShapeStyle == ShapeStyle.outline
              ? PaintroidTheme.of(context).primaryColor
              : Colors.white,
          onPressed: () => ref
              .read(shapesToolOptionsStateProvider.notifier)
              .setShapeStyle(ShapeStyle.outline),
        ),
      ),
      CustomActionChip(
        key: const ValueKey(WidgetIdentifier.fillStyleChip),
        hint: 'Fill',
        chipIcon: Icon(
          Icons.square,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        chipBackgroundColor: currentShapeStyle == ShapeStyle.fill
            ? PaintroidTheme.of(context).primaryColor
            : Colors.white,
        onPressed: () => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeStyle(ShapeStyle.fill),
      ),
      CustomActionChip(
        key: const ValueKey(WidgetIdentifier.dashedStyleChip),
        hint: 'Dashed',
        chipIcon: Icon(
          Icons.border_style_outlined,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        chipBackgroundColor: currentShapeStyle == ShapeStyle.dashed
            ? PaintroidTheme.of(context).primaryColor
            : Colors.white,
        onPressed: () => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeStyle(ShapeStyle.dashed),
      ),
      CustomActionChip(
        key: const ValueKey(WidgetIdentifier.fillAndDashedStyleChip),
        hint: 'Fill & Dashed',
        chipIcon: Icon(
          Icons.texture,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        chipBackgroundColor: currentShapeStyle == ShapeStyle.fillAndDashed
            ? PaintroidTheme.of(context).primaryColor
            : Colors.white,
        onPressed: () => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeStyle(ShapeStyle.fillAndDashed),
      ),
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shapeStyleItems.length,
        itemBuilder: (context, index) => shapeStyleItems[index],
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
