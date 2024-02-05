import 'package:command/command_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

part 'line_tool_provider.g.dart';

@riverpod
LineTool lineTool(LineToolRef ref) {
  return LineTool(
      paint: ref.watch(brushToolStateProvider.select((state) => state.paint)),
      type: ToolType.LINE,
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      drawingSurfaceSize:
          ref.watch(canvasStateProvider.select((state) => state.size)));
}
