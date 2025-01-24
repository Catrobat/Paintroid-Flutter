import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/hand_tool.dart';

void main() {
  late HandTool sut;
  setUp(() {
    sut = HandTool(
      type: ToolType.HAND,
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      layerKey: const ValueKey(0),
    );
  });

  test('Should return Hand as ToolType', () {
    expect(sut.type, ToolType.HAND);
  });
}
