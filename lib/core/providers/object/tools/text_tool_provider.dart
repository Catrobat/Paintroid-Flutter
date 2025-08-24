import 'dart:ui';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/text_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';

part 'text_tool_provider.g.dart';

@riverpod
class TextToolProvider extends _$TextToolProvider {
  @override
  TextTool build() {
    final canvasSize = ref.read(canvasStateProvider).size;
    final initialCenter = canvasSize.center(Offset.zero);
    Rect initialRect = Rect.fromCenter(
      center: initialCenter,
      width: 150,
      height: 75,
    );
    final defaultOptions = const TextToolOptionsStateData();
    return TextTool(
      graphicFactory: ref.watch(graphicFactoryProvider),
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
      type: ToolType.TEXT,
      boundingBox: BoundingBox.fromRect(initialRect),
      options: defaultOptions,
      onUserManuallyResized: (newFontSize) {
        final notifier = ref.read(textToolOptionsStateProvider.notifier);
        notifier.setFontSize(newFontSize);
        notifier.setAutoSize(false);
      },
    );
  }
}
