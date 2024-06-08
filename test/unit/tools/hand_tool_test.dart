// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/sync_command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/hand_tool.dart';

void main() {
  late HandTool sut;
  setUp(() {
    sut = HandTool(
      type: ToolType.HAND,
      paint: Paint(),
      commandFactory: const CommandFactory(),
      commandManager: SyncCommandManager(commands: []),
    );
  });

  test('Should return Hand as ToolType', () {
    expect(sut.type, ToolType.HAND);
  });
}
