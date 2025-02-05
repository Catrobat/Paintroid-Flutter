import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/spray_tool.dart';

void main() {
  late SprayTool sut;

  const Offset pointA = Offset(100, 100);
  const Offset pointB = Offset(200, 200);

  Paint paint = Paint();

  setUp(() {
    sut = SprayTool(
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      graphicFactory: const GraphicFactory(),
      type: ToolType.SPRAY,
      drawingSurfaceSize: const Size(1000, 1000),
    );
  });

  group('On tap down event', () {
    test('Should create one SprayCommand with initial points', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      expect(sut.commandManager.undoStack.length, 1);
      expect(sut.commandManager.undoStack.first is SprayCommand, true);
      final sprayCommand = sut.commandManager.undoStack.first as SprayCommand;
      expect(sprayCommand.points.isNotEmpty, true);
    });

    test('SprayCommand points should increase on onDrag', () {
      sut.onDown(pointA, paint);
      final sprayCommand = sut.commandManager.undoStack.first as SprayCommand;
      int initialPointCount = sprayCommand.points.length;
      sut.onDrag(pointB, paint);
      expect(sprayCommand.points.length, greaterThan(initialPointCount));
    });

    test('Generated spray points should be within sprayRadius * 2', () {
      sut.updateSprayRadius(50.0);
      sut.onDown(pointA, paint);
      final sprayCommand = sut.commandManager.undoStack.first as SprayCommand;
      for (var point in sprayCommand.points) {
        double distance = (point - pointA).distance;
        expect(distance, lessThanOrEqualTo(50.0 * 2));
      }
    });

    test('On tap up, no additional commands are created', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.commandManager.undoStack.length, 1);
    });
  });

  group('SprayTool properties and methods', () {
    test('Should return SPRAY as ToolType', () {
      expect(sut.type, ToolType.SPRAY);
    });

    test('updateSprayRadius should change sprayRadius', () {
      double initialRadius = sut.sprayRadius;
      sut.updateSprayRadius(80.0);
      expect(sut.sprayRadius, equals(80.0));
      expect(sut.sprayRadius, isNot(equals(initialRadius)));
    });

    test('Spray density adjusts with sprayRadius', () {
      sut.updateSprayRadius(30.0);
      sut.onDown(pointA, paint);
      final sprayCommand1 = sut.commandManager.undoStack.last as SprayCommand;
      int pointCount30 = sprayCommand1.points.length;

      sut.updateSprayRadius(60.0);
      sut.onDown(pointB, paint);
      final sprayCommand2 = sut.commandManager.undoStack.last as SprayCommand;
      int pointCount60 = sprayCommand2.points.length;

      expect(pointCount60, greaterThan(pointCount30));
    });

    test('onCancel discards the last command', () {
      sut.onDown(pointA, paint);
      expect(sut.commandManager.undoStack.length, 1);
      sut.onCancel();
      expect(sut.commandManager.undoStack.isEmpty, true);
    });

    test('onUndo removes the last command from the undoStack', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.commandManager.undoStack.length, 1);
      sut.onUndo();
      expect(sut.commandManager.undoStack.length, 0);
    });
  });
}
