import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/providers/object/shapes_tool_options_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';

class ShapesToolShapeStyleOptions extends ConsumerWidget {
  const ShapesToolShapeStyleOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(shapesToolOptionsStateProvider).shapeStyle;
    final shapeStyle = [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ChoiceChip(
          key: ValueKey(WidgetIdentifier.outlineStyleChip),
          label: const Text('Outline'),
          selected: style == ShapeStyle.outline,
          onSelected: (_) => ref
              .read(shapesToolOptionsStateProvider.notifier)
              .setShapeStyle(ShapeStyle.outline),
        ),
      ),
      ChoiceChip(
        key: ValueKey(WidgetIdentifier.fillStyleChip),
        label: const Text('Fill'),
        selected: style == ShapeStyle.fill,
        onSelected: (_) => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeStyle(ShapeStyle.fill),
      ),
      ChoiceChip(
        key: ValueKey(WidgetIdentifier.dashedStyleChip),
        label: const Text('Dashed'),
        selected: style == ShapeStyle.dashed,
        onSelected: (_) => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeStyle(ShapeStyle.dashed),
      ),
      ChoiceChip(
        key: ValueKey(WidgetIdentifier.fillAndDashedStyleChip),
        label: const Text('Fill & Dashed'),
        selected: style == ShapeStyle.fillAndDashed,
        onSelected: (_) => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeStyle(ShapeStyle.fillAndDashed),
      ),
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shapeStyle.length,
        itemBuilder: (context, index) => shapeStyle[index],
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
