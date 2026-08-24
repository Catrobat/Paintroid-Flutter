import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

void main() {
  late BrushTool sut;

  const Offset pointA = Offset(0, 0);
  const Offset pointB = Offset(200, 200);

  Paint paint = Paint();

  setUp(() {
    sut = BrushTool(
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      isSmoothingEnabled: () => false,
      graphicFactory: const GraphicFactory(),
      type: ToolType.BRUSH,
    );
  });

  group('On tap down event', () {
    test('Should create one PathCommand with a new Path', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      expect(sut.commandManager.undoStack.first is PathCommand, true);
    });

    test('After tap up a new PathCommand is created', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.commandManager.undoStack.length, 1);
      sut.onDown(pointB, paint);
      sut.onUp(pointB, paint);
      expect(sut.commandManager.undoStack.length, 2);
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

  test('Should return Brush as ToolType', () {
    expect(sut.type, ToolType.BRUSH);
  });

  group('Speed-based smoothing', () {
    test(
        'a fast move applies smoothing even after a long pause earlier in the stroke',
        () {
      int clock = 0;
      final smoothingSut = BrushTool(
        commandFactory: const CommandFactory(),
        commandManager: CommandManager(),
        isSmoothingEnabled: () => true,
        graphicFactory: const GraphicFactory(),
        type: ToolType.BRUSH,
        now: () => clock,
      );

      smoothingSut.onDown(const Offset(0, 0), paint);

      clock += 1;
      smoothingSut.onDrag(const Offset(10, 0), paint);

      clock += 1;
      smoothingSut.onDrag(const Offset(20, 0), paint);

      clock += 100000;
      smoothingSut.onDrag(const Offset(30, 0), paint);
      var actionsAfterPause =
          (smoothingSut.commandManager.undoStack.first as PathCommand)
              .path
              .actions;
      expect(
        actionsAfterPause.last,
        isA<LineToAction>(),
        reason: 'a slow move (large timeDiff) must not be smoothed',
      );

      clock += 1;
      smoothingSut.onDrag(const Offset(40, 0), paint);
      var actionsAfterFastMove =
          (smoothingSut.commandManager.undoStack.first as PathCommand)
              .path
              .actions;
      expect(
        actionsAfterFastMove.last,
        isA<CubicToAction>(),
        reason:
            'a fast move right after a pause must still trigger smoothing',
      );
    });
  });

  group('Touch-up endpoint', () {
    test('onUp extends the path to the final touch-up point', () {
      sut.onDown(const Offset(0, 0), paint);
      sut.onDrag(const Offset(50, 50), paint);

      const liftPoint = Offset(52, 52);
      sut.onUp(liftPoint, paint);

      final lastAction =
          (sut.commandManager.undoStack.first as PathCommand).path.actions.last;
      expect(lastAction, isA<LineToAction>());
      lastAction as LineToAction;
      expect(Offset(lastAction.x, lastAction.y), liftPoint);
    });
  });
}
