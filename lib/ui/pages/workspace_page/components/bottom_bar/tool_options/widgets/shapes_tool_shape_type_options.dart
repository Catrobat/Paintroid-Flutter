import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/shapes_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ShapesToolShapeTypeOptions extends ConsumerWidget {
  const ShapesToolShapeTypeOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    final shapeToolSelected = currentTool.type == ToolType.SHAPES;
    final shapesToolOptionsState = ref.watch(shapesToolOptionsStateProvider);
    final shapeItems = [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CustomActionChip(
          key: const ValueKey(
            WidgetIdentifier.squareShapeTypeChip,
          ),
          hint: 'Square',
          chipBackgroundColor:
              shapesToolOptionsState.shapeType == ShapeType.square
                  ? PaintroidTheme.of(context).primaryColor
                  : Colors.white,
          chipIcon: Icon(
            Icons.square_outlined,
            color: PaintroidTheme.of(context).shadowColor,
          ),
          onPressed: () => ref
              .read(shapesToolOptionsStateProvider.notifier)
              .setShapeType(shapeType: ShapeType.square),
        ),
      ),
      CustomActionChip(
        key: const ValueKey(
          WidgetIdentifier.ellipseShapeTypeChip,
        ),
        hint: 'Ellipse',
        chipBackgroundColor:
            shapesToolOptionsState.shapeType == ShapeType.ellipse
                ? PaintroidTheme.of(context).primaryColor
                : Colors.white,
        chipIcon: Icon(
          Icons.circle_outlined,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        onPressed: () => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeType(shapeType: ShapeType.ellipse),
      ),
      CustomActionChip(
        key: const ValueKey(
          WidgetIdentifier.starShapeTypeChip,
        ),
        hint: 'Star',
        chipBackgroundColor: shapesToolOptionsState.shapeType == ShapeType.star
            ? PaintroidTheme.of(context).primaryColor
            : Colors.white,
        chipIcon: Icon(
          Icons.star_outline,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        onPressed: () => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeType(shapeType: ShapeType.star),
      ),
      CustomActionChip(
        key: const ValueKey(
          WidgetIdentifier.heartShapeTypeChip,
        ),
        hint: 'Heart',
        chipBackgroundColor: shapesToolOptionsState.shapeType == ShapeType.heart
            ? PaintroidTheme.of(context).primaryColor
            : Colors.white,
        chipIcon: Icon(
          Icons.favorite_outline,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        onPressed: () => ref
            .read(shapesToolOptionsStateProvider.notifier)
            .setShapeType(shapeType: ShapeType.heart),
      )
    ];

    return !shapeToolSelected
        ? const SizedBox.shrink()
        : SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: shapeItems.length,
              itemBuilder: (context, index) => shapeItems[index],
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          );
  }
}
