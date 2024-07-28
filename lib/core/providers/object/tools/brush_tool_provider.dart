
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

part 'brush_tool_provider.g.dart';

@riverpod
class BrushToolProvider extends _$BrushToolProvider {
  @override
  BrushTool build() {
    return BrushTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      type: ToolType.BRUSH,
    );
  }
}
