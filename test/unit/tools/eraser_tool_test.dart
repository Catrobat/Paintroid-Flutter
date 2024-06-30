import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/eraser_tool.dart';

void main() {
  late EraserTool sut;

  setUp(() {
    sut = EraserTool(
      type: ToolType.ERASER,
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      graphicFactory: const GraphicFactory(),
    );
  });

  test('Should return Eraser as ToolType', () {
    expect(sut.type, ToolType.ERASER);
  });
}
