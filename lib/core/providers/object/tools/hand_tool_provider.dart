
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/hand_tool.dart';

part 'hand_tool_provider.g.dart';

@riverpod
class HandToolProvider extends _$HandToolProvider {
  @override
  HandTool build() {
    return HandTool(
    commandManager: ref.watch(commandManagerProvider),
    commandFactory: ref.watch(commandFactoryProvider),
    type: ToolType.HAND,
  );
  }
}