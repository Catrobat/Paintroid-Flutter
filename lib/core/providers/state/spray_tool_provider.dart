import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/spray_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spray_tool_provider.g.dart';

@riverpod
class SprayToolProvider extends _$SprayToolProvider {
  @override
  SprayTool build() {
    return SprayTool(
      type: ToolType.SPRAY,
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
    );
  }
}
