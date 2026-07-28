import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/models/path_actions/move_to_action.dart';
import 'package:paintroid/core/models/path_actions/line_to_action.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/cursor_tool.dart';

void main() {
  late CursorTool sut;

  const Offset pointA = Offset(100, 100);
  const Offset pointB = Offset(200, 200);
  const Offset canvasCenter = Offset(150, 150);

  Paint paint = Paint();

  setUp(() {
    sut = CursorTool(
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      graphicFactory: const GraphicFactory(),
      canvasCenter: canvasCenter,
      type: ToolType.CURSOR,
    );
  });

  group('Initialization', () {
    test('Should initialize with cursor at canvas center', () {
      expect(sut.lastPoint, canvasCenter);
    });

    test('Should initialize with inactive state', () {
      expect(sut.isActive, false);
    });

    test('Should return CURSOR as ToolType', () {
      expect(sut.type, ToolType.CURSOR);
    });
  });

  group('Cursor positioning', () {
    test('Should set cursor position correctly', () {
      sut.setCursorPosition(pointA);
      expect(sut.lastPoint, pointA);
    });

    test('Should update cursor position when dragging', () {
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);

      final expectedPosition = canvasCenter + (pointB - pointA);
      expect(sut.lastPoint, expectedPosition);
    });
  });

  group('Active state management', () {
    test('Should toggle active state', () {
      expect(sut.isActive, false);
      sut.toggleActive();
      expect(sut.isActive, true);
      sut.toggleActive();
      expect(sut.isActive, false);
    });

    test('Should toggle active state on tap', () {
      expect(sut.isActive, false);
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.isActive, true);
    });

    test('Should deactivate when tapping while active', () {
      sut.toggleActive();
      expect(sut.isActive, true);

      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.isActive, false);
    });
  });

  group('Drawing behavior when inactive', () {
    test('Should not create PathCommand when inactive on down', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      expect(sut.commandManager.undoStack.isEmpty, true);
    });

    test('Should not create PathCommand when inactive on drag', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      expect(sut.commandManager.undoStack.isEmpty, true);
    });

    test('Should not create PathCommand when inactive on up', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      sut.onUp(pointB, paint);
      expect(sut.commandManager.undoStack.isEmpty, true);
    });
  });

  group('Drawing behavior when active', () {
    setUp(() {
      sut.toggleActive();
    });

    test('Should create PathCommand when active on drag', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      expect(sut.commandManager.undoStack.first is PathCommand, true);
    });

    test('Should add MoveToAction when active on drag', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      final firstAction = (sut.commandManager.undoStack.first as PathCommand)
          .path
          .actions
          .first;
      expect(firstAction is MoveToAction, true);
    });

    test('Should add LineToAction when active on drag', () {
      expect(sut.commandManager.undoStack.isEmpty, true);
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      final lastAction =
          (sut.commandManager.undoStack.first as PathCommand).path.actions.last;
      expect(lastAction is LineToAction, true);
    });

    test('Should create new PathCommand after completing a stroke', () {
      expect(sut.commandManager.undoStack.isEmpty, true);

      const dragOffset = Offset(20, 20);
      sut.onDown(pointA, paint);
      sut.onDrag(pointA + dragOffset, paint);
      sut.onUp(pointA + dragOffset, paint);
      expect(sut.commandManager.undoStack.length, 1);

      sut.onDown(pointB, paint);
      sut.onDrag(pointB + dragOffset, paint);
      sut.onUp(pointB + dragOffset, paint);
      expect(sut.commandManager.undoStack.length, 2);
    });
  });

  group('Tap vs Drag detection', () {
    test('Should detect tap when movement is within tolerance', () {
      const smallOffset = Offset(5, 5);

      sut.onDown(pointA, paint);
      sut.onDrag(pointA + smallOffset, paint);
      sut.onUp(pointA + smallOffset, paint);

      expect(sut.isActive, true);
    });

    test('Should detect drag when movement exceeds tolerance', () {
      const largeOffset = Offset(50, 50);

      sut.onDown(pointA, paint);
      sut.onDrag(pointA + largeOffset, paint);
      sut.onUp(pointA + largeOffset, paint);

      expect(sut.isActive, false);
    });
  });

  group('Cursor position tracking during drag', () {
    test('Should maintain cursor position relative to initial touch', () {
      final initialCursorPos = sut.lastPoint;
      const touchPoint = Offset(100, 100);
      const dragPoint = Offset(150, 150);

      sut.onDown(touchPoint, paint);
      sut.onDrag(dragPoint, paint);

      final expectedCursorPos = initialCursorPos + (dragPoint - touchPoint);
      expect(sut.lastPoint, expectedCursorPos);
    });

    test('Should update cursor position correctly through multiple drags', () {
      final initialCursorPos = sut.lastPoint;
      const touchPoint = Offset(100, 100);
      const dragPoint1 = Offset(150, 150);
      const dragPoint2 = Offset(200, 200);

      sut.onDown(touchPoint, paint);
      sut.onDrag(dragPoint1, paint);
      sut.onDrag(dragPoint2, paint);

      final expectedCursorPos = initialCursorPos + (dragPoint2 - touchPoint);
      expect(sut.lastPoint, expectedCursorPos);
    });
  });

  group('State reset', () {
    test('Should reset tracking state after completing gesture', () {
      sut.onDown(pointA, paint);
      sut.onDrag(pointB, paint);
      sut.onUp(pointB, paint);
      expect(sut.isActive, false);
    });
  });
}
