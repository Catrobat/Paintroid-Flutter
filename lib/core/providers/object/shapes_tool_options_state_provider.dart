import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/shapes_tool_options_state_data.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shapes_tool_options_state_provider.g.dart';

@riverpod
class ShapesToolOptionsStateProvider extends _$ShapesToolOptionsStateProvider {
  @override
  ShapesToolOptionsStateData build() {
    return const ShapesToolOptionsStateData(
      isRotating: false,
      shapeType: ShapeType.square,
    );
  }

  void setIsRotating({required bool isRotating}) {
    state = state.copyWith(isRotating: isRotating);
    _handleCurrentTool();
    ref.read(canvasPainterProvider.notifier).repaint();
    ref.notifyListeners();
  }

  void setShapeType({required ShapeType shapeType}) {
    state = state.copyWith(shapeType: shapeType);
    _handleCurrentTool();
    ref.read(canvasPainterProvider.notifier).repaint();
    ref.notifyListeners();
  }

  void _handleCurrentTool() {
    if (ref.read(toolBoxStateProvider).currentTool.type == ToolType.SHAPES) {
      final shapesTool =
          ref.read(toolBoxStateProvider).currentTool as ShapesTool;
      shapesTool.isRotating = state.isRotating;
      shapesTool.shapeType = state.shapeType;
    }
  }
}
