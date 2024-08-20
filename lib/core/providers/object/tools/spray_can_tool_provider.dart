import 'package:paintroid/core/tools/implementation/spray_can_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';

part 'spray_can_tool_provider.g.dart';

@riverpod
class SprayCanToolProvider extends _$SprayCanToolProvider {
  @override
  SprayCanTool build() {
    return SprayCanTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      type: ToolType.SPRAY,
    );
  }
}
