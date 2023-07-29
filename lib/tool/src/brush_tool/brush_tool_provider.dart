import 'package:paintroid/command/src/command_factory_provider.dart';
import 'package:paintroid/command/src/command_manager_provider.dart';
import 'package:paintroid/core/graphic_factory_provider.dart';
import 'package:paintroid/tool/src/brush_tool/brush_tool.dart';
import 'package:paintroid/tool/src/brush_tool/brush_tool_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brush_tool_provider.g.dart';

@riverpod
BrushTool brushTool(BrushToolRef ref) {
  return BrushTool(
    paint: ref.watch(brushToolStateProvider.select((state) => state.paint)),
    commandManager: ref.watch(commandManagerProvider),
    commandFactory: ref.watch(commandFactoryProvider),
    graphicFactory: ref.watch(graphicFactoryProvider),
  );
}
