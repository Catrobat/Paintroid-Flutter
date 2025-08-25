import 'dart:ui';

import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/shapes_tool_options_state_data.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shapes_tool_options_state_provider.g.dart';

@riverpod
class ShapesToolOptionsStateProvider extends _$ShapesToolOptionsStateProvider {
  @override
  ShapesToolOptionsStateData build() {
    return const ShapesToolOptionsStateData(
        shapeType: ShapeType.square, shapeStyle: ShapeStyle.outline);
  }

  void setShapeType({required ShapeType shapeType}) {
    state = state.copyWith(shapeType: shapeType);
    _updateActiveShapesToolAndResetBoundingBox();
    ref.read(canvasPainterProvider.notifier).repaint();
  }

  void setShapeStyle(ShapeStyle style) {
    state = state.copyWith(shapeStyle: style);
    _updateActiveShapesToolAndResetBoundingBox();
    ref.read(canvasPainterProvider.notifier).repaint();
  }

  void _updateActiveShapesToolAndResetBoundingBox() {
    final toolBoxData = ref.read(toolBoxStateProvider);
    final currentToolInstance = toolBoxData.currentTool;

    if (currentToolInstance.type == ToolType.SHAPES &&
        currentToolInstance is ShapesTool) {
      final canvasState = ref.read(canvasStateProvider);
      final canvasCenter = canvasState.size.center(Offset.zero);

      if(currentToolInstance.style == state.shapeStyle) {
        currentToolInstance.boundingBox.angle = 0.0;
        currentToolInstance.boundingBox.width = 300.0;
        currentToolInstance.boundingBox.height = 300.0;
        currentToolInstance.boundingBox.center = canvasCenter;
      }

      currentToolInstance.shapeType = state.shapeType;
      currentToolInstance.style = state.shapeStyle;
    }
  }
}
