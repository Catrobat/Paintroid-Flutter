import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ShapesToolShapeTypeOptions extends StatefulWidget {
  const ShapesToolShapeTypeOptions({super.key});

  @override
  State<ShapesToolShapeTypeOptions> createState() =>
      _ShapesToolShapeTypeOptionsState();
}

class _ShapesToolShapeTypeOptionsState
    extends State<ShapesToolShapeTypeOptions> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentTool = ref.read(toolBoxStateProvider).currentTool;
        final shapeToolSelected = currentTool.type == ToolType.SHAPES;
        final shapesTool = currentTool as ShapesTool;
        return !shapeToolSelected
            ? const SizedBox.shrink()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      CustomActionChip(
                        hint: 'Square',
                        chipBackgroundColor:
                            shapesTool.shapeType == ShapeType.rectangle
                                ? PaintroidTheme.of(context).primaryColor
                                : Colors.white,
                        chipIcon: Icon(
                          Icons.square_outlined,
                          color: PaintroidTheme.of(context).shadowColor,
                        ),
                        onPressed: () {
                          shapesTool.shapeType = ShapeType.rectangle;
                          ref.read(canvasPainterProvider.notifier).repaint();
                          setState(() {});
                        },
                      ),
                      CustomActionChip(
                        hint: 'Circle',
                        chipBackgroundColor:
                            shapesTool.shapeType == ShapeType.circle
                                ? PaintroidTheme.of(context).primaryColor
                                : Colors.white,
                        chipIcon: Icon(
                          Icons.circle_outlined,
                          color: PaintroidTheme.of(context).shadowColor,
                        ),
                        onPressed: () {
                          shapesTool.shapeType = ShapeType.circle;
                          ref.read(canvasPainterProvider.notifier).repaint();
                          setState(() {});
                        },
                      )
                    ],
                  )
                ],
              );
      },
    );
  }
}
