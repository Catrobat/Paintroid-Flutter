import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';

part 'shapes_tool_provider.g.dart';

@riverpod
class ShapesToolProvider extends _$ShapesToolProvider {
  @override
  ShapesTool build() {
    return ShapesTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      type: ToolType.SHAPES,
    );
  }
}
