import 'package:command/command_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tools/tools.dart';

part 'hand_tool_provider.g.dart';

@riverpod
HandTool handTool(HandToolRef ref) {
  return HandTool(
    paint: ref.watch(brushToolStateProvider.select((state) => state.paint)),
    commandManager: ref.watch(commandManagerProvider),
    commandFactory: ref.watch(commandFactoryProvider),
  );
}
