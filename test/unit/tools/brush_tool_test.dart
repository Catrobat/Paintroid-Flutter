// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_manager/sync_command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

void main() {
  late BrushTool sut;

  const Offset pointA = Offset(0, 0);
  const Offset pointB = Offset(200, 200);

  setUp(() {
    sut = BrushTool(
      paint: Paint(),
      commandFactory: const CommandFactory(),
      commandManager: SyncCommandManager(commands: []),
      graphicFactory: const GraphicFactory(),
      type: ToolType.BRUSH,
    );
  });

  group('On tap down event', () {
    test('Should create one PathCommand with a new Path', () {
      expect(sut.commandManager.history.isEmpty, true);
      sut.onDown(pointA);
      expect(sut.commandManager.history.first is PathCommand, true);
    });

    test('After tap up a new PathCommand is created', () {
      expect(sut.commandManager.history.isEmpty, true);
      sut.onDown(pointA);
      sut.onUp(pointA);
      expect(sut.commandManager.history.length, 1);
      sut.onDown(pointB);
      sut.onUp(pointB);
      expect(sut.commandManager.history.length, 2);
    });

    test('On tap down adds MoveToAction', () {
      expect(sut.commandManager.history.isEmpty, true);
      sut.onDown(pointA);
      final firstAction =
          (sut.commandManager.history.first as PathCommand).path.actions.first;
      expect(firstAction is MoveToAction, true);
    });

    test('On drag adds LineToAction', () {
      expect(sut.commandManager.history.isEmpty, true);
      sut.onDown(pointA);
      sut.onDrag(pointB);
      final lastAction =
          (sut.commandManager.history.first as PathCommand).path.actions.last;
      expect(lastAction is LineToAction, true);
    });

    test('On tap up closes the path', () {
      expect(sut.commandManager.history.isEmpty, true);
      sut.onDown(pointA);
      sut.onUp(pointA);
      final lastAction =
          (sut.commandManager.history.first as PathCommand).path.actions.last;
      expect(lastAction is CloseAction, true);
    });
  });

  test('Should return Brush as ToolType', () {
    expect(sut.type, ToolType.BRUSH);
  });
}
