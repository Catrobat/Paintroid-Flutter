import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/clipping_tool.dart';
import 'package:paintroid/core/providers/object/tools/clipping_tool_state_provider.dart';

part 'clipping_tool_provider.g.dart';

@riverpod
class ClippingToolProvider extends _$ClippingToolProvider {
  @override
  ClippingTool build() {
    return ClippingTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      clippingToolState: ref.watch(clippingToolState.notifier),
      type: ToolType.CLIPPING,
    );
  }
}
