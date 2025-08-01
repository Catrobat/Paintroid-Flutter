import 'dart:ui';

import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/tools/implementation/clipboard_tool.dart';

part 'clipboard_tool_provider.g.dart';

@Riverpod(keepAlive: true)
class ClipboardToolProvider extends _$ClipboardToolProvider {
  @override
  ClipboardTool build() {
    Rect initialBoundingBox = Rect.fromCenter(
      center: ref.read(canvasStateProvider).size.center(Offset.zero),
      width: 300,
      height: 300,
    );
    return ClipboardTool(
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      boundingBox: BoundingBox.fromRect(initialBoundingBox),
      type: ToolType.CLIPBOARD,
    );
  }
}
