import 'package:paintroid/command/src/command_factory_provider.dart';
import 'package:paintroid/command/src/command_manager_provider.dart';
import 'package:paintroid/tool/src/brush_tool/brush_tool_state_provider.dart';
import 'package:paintroid/tool/src/hand_tool/hand_tool.dart';
import 'package:paintroid/tool/src/tool_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hand_tool_provider.g.dart';

@riverpod
HandTool handTool(HandToolRef ref) {
  return HandTool(
    paint: ref.watch(brushToolStateProvider.select((state) => state.paint)),
    type: ToolType.HAND,
    commandManager: ref.watch(commandManagerProvider),
    commandFactory: ref.watch(commandFactoryProvider),
  );
}
