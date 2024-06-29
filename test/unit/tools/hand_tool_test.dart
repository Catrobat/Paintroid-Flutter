// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
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
    );
  });

  test('Should return Hand as ToolType', () {
    expect(sut.type, ToolType.HAND);
  });
}
