import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/fill_tool.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';

part 'fill_tool_provider.g.dart';

@riverpod
class FillToolProvider extends _$FillToolProvider {
  @override
  FillTool build() {
    return FillTool(
      type: ToolType.FILL,
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      canvasStateProvider: ref.watch(canvasStateProvider.notifier),
      canvasPainterProvider: ref.watch(canvasPainterProvider.notifier)
    );
  }
}