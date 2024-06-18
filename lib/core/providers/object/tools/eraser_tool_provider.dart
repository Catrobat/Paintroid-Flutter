// Package imports:

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/tools/brush/brush_tool_state_provider.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

part 'eraser_tool_provider.g.dart';

@riverpod
class EraserToolProvider extends _$EraserToolProvider {
  @override
  BrushTool build() {
    return BrushTool(
      paint: ref.watch(brushToolStateProvider.select((state) => state.paint)),
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      type: ToolType.ERASER,
    );
  }
}
