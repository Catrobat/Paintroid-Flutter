import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/watercolor_tool.dart';

void main() {
  late WatercolorTool sut;

  const Offset pointA = Offset(0, 0);
  const Offset pointB = Offset(200, 200);

  Paint paint = Paint();

  setUp(() {
    sut = WatercolorTool(
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      graphicFactory: const GraphicFactory(),
      type: ToolType.WATERCOLOR,
    );
  });

  group('On tap down event for WatercolorTool', () {
    test(
        'Should create one PathCommand with a new Path and a MaskFilter in paint',
        () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      expect(sut.commandManager.undoStack.first is PathCommand, true);
      final commandPaint =
          (sut.commandManager.undoStack.first as PathCommand).paint;
      expect(commandPaint.maskFilter, isNotNull);
      expect(commandPaint.maskFilter is MaskFilter, true);
    });

    test('After tap up a new PathCommand is created with a MaskFilter in paint',
        () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.commandManager.undoStack.length, 1);
      final firstCommandPaint =
          (sut.commandManager.undoStack.first as PathCommand).paint;
      expect(firstCommandPaint.maskFilter, isNotNull);

      sut.onDown(pointB, paint);
      sut.onUp(pointB, paint);
      expect(sut.commandManager.undoStack.length, 2);
      final secondCommandPaint =
          (sut.commandManager.undoStack.last as PathCommand).paint;
      expect(secondCommandPaint.maskFilter, isNotNull);
    });

    test('On tap down adds MoveToAction', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      final firstAction = (sut.commandManager.undoStack.first as PathCommand)
          .path
          .actions
          .first;
      expect(firstAction is MoveToAction, true);
    });

    test('On drag adds LineToAction', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      final lastAction =
          (sut.commandManager.undoStack.first as PathCommand).path.actions.last;
      expect(lastAction is LineToAction, true);
    });

    test('On tap up closes the path', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      final lastAction =
          (sut.commandManager.undoStack.first as PathCommand).path.actions.last;
      expect(lastAction is CloseAction, true);
    });
  });

  test('Should return WATERCOLOR as ToolType', () {
    expect(sut.type, ToolType.WATERCOLOR);
  });
}
