import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/tools/implementation/pipette_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pipette_tool_provider.g.dart';

@riverpod
class PipetteToolProvider extends _$PipetteToolProvider {
  @override
  PipetteTool build() {
    return PipetteTool(
      commandFactory: ref.watch(commandFactoryProvider),
      commandManager: ref.watch(commandManagerProvider),
      type: ToolType.PIPETTE,
      paintProvider: ref.watch(paintProvider.notifier),
      canvasStateProvider: ref.watch(canvasStateProvider.notifier),
    );
  }
}
