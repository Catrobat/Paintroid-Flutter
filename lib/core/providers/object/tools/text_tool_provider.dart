import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/text_tool/text_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/providers/state/tools/brush/brush_tool_state_provider.dart';

part 'text_tool_provider.g.dart';

@riverpod
class TextToolProvider extends _$TextToolProvider {
  @override
  TextTool build() {
    return TextTool(
      stateData: ref.watch(canvasStateProvider),
      paint: ref.watch(brushToolStateProvider.select((state) => state.paint)),
      commandManager: ref.watch(commandManagerProvider),
      commandFactory: ref.watch(commandFactoryProvider),
    );
  }
}
