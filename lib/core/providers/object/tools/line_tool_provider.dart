// Package imports:

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';

part 'line_tool_provider.g.dart';

@riverpod
class LineToolProvider extends _$LineToolProvider {
  @override
  LineTool build() {
    return LineTool(
    paint: ref.watch(paintProvider),
    type: ToolType.LINE,
    commandManager: ref.watch(commandManagerProvider),
    commandFactory: ref.watch(commandFactoryProvider),
    graphicFactory: ref.watch(graphicFactoryProvider),
    drawingSurfaceSize: ref.watch(
      canvasStateProvider.select((state) => state.size),
    ),
  );
  }
}