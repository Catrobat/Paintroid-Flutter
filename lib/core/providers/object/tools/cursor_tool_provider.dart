import 'dart:ui';

import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/implementation/cursor_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';

part 'cursor_tool_provider.g.dart';

@riverpod
class CursorToolProvider extends _$CursorToolProvider {
  @override
  CursorTool build() {
    final canvasCenter = ref.read(canvasStateProvider).size.center(Offset.zero);
    return CursorTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      isSmoothingEnabled: () => ref.read(advancedSettingsProvider).isSmoothingEnabled,
      canvasCenter: canvasCenter,
      type: ToolType.CURSOR,
    );
  }
}
