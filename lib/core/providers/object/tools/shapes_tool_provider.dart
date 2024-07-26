import 'package:flutter/painting.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';

part 'shapes_tool_provider.g.dart';

@Riverpod(keepAlive: true)
class ShapesToolProvider extends _$ShapesToolProvider {
  @override
  ShapesTool build() {
    return ShapesTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      type: ToolType.SHAPES,
      boundingBox: Rect.fromCenter(
        center: ref.read(canvasStateProvider).size.center(Offset.zero),
        width: 150,
        height: 150,
      ),
    );
  }

  void switchBoundingBoxTransformationMode() {
    state = state.copyWith(
      isRotating: !state.isRotating,
      isTranslatingAndScaling: state.isTranslatingAndScaling,
    );
  }
}
