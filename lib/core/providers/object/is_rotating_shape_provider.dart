import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_rotating_shape_provider.g.dart';

@riverpod
class IsRotatingShapeProvider extends _$IsRotatingShapeProvider {
  @override
  bool build() {
    return false;
  }

  void rotating() {
    state = true;
    ref.read(canvasPainterProvider.notifier).repaint();
    _setShapesToolIsRotating();
  }

  void notRotating() {
    state = false;
    ref.read(canvasPainterProvider.notifier).repaint();
    _setShapesToolIsRotating();
  }

  void _setShapesToolIsRotating() {
    if (ref.read(toolBoxStateProvider).currentTool.type == ToolType.SHAPES) {
      final shapesTool =
          ref.read(toolBoxStateProvider).currentTool as ShapesTool;
      shapesTool.isRotating = state;
    }
  }
}
