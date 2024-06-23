// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';

void main() {
  late LineTool sut;

  const Offset pointA = Offset(0, 0);
  const Offset pointB = Offset(200, 200);
  const Offset pointC = Offset(400, 400);
  const Offset pointD = Offset(600, 600);
  Paint paint = Paint();

  setUp(() {
    sut = LineTool(
      type: ToolType.LINE,
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      graphicFactory: const GraphicFactory(),
      drawingSurfaceSize: const Size(1000, 1000),
    );
  });

  group('On tap down event', () {
    test('VertexStack should have two vertices after first click', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA, paint);
      expect(sut.vertexStack.length, 2);
    });

    test('VertexStack should have three vertices after second click', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      expect(sut.vertexStack.length, 2);
      sut.onPlus();
      sut.onDown(pointC, paint);
      expect(sut.vertexStack.length, 3);
    });

    test('VertexStack should have four vertices after third click', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      expect(sut.vertexStack.length, 2);
      sut.onPlus();
      sut.onDown(pointC, paint);
      expect(sut.vertexStack.length, 3);
      sut.onPlus();
      sut.onDown(pointD, paint);
      expect(sut.vertexStack.length, 4);
    });

    test('VertexStack resets after clicking checkmark', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      expect(sut.vertexStack.length, 2);
      sut.onCheckmark();
      expect(sut.vertexStack.length, 0);
    });

    test('AddNewPath is true after click plus', () {
      expect(sut.addNewPath, false);
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      sut.onPlus();
      expect(sut.addNewPath, true);
    });

    test('Last vertex is set to movingVertex after click plus', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointC, paint);
      sut.onUp(pointC, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointD, paint);
      sut.onUp(pointD, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
    });

    test('Click on first vertex sets it to movingVertex', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointC, paint);
      sut.onUp(pointC, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onDown(pointA, paint);
      sut.onUp(pointA, paint);
      expect(sut.movingVertex, sut.vertexStack.first);
    });

    test('Click on middle vertex sets it to movingVertex', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointC, paint);
      sut.onUp(pointC, paint);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onDown(pointB, paint);
      sut.onUp(pointB, paint);
      expect(sut.movingVertex, sut.vertexStack.elementAt(1));
    });

    test('Moving a vertex changes its vertexCenter', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      sut.onPlus();
      sut.onDown(pointC, paint);
      sut.onUp(pointC, paint);
      expect(sut.vertexStack.first.vertexCenter, pointA);
      sut.onDown(pointA, paint);
      sut.onDrag(pointD, paint);
      sut.onUp(pointD, paint);
      expect(sut.vertexStack.first.vertexCenter, pointD);
    });

    test('Last vertexCenter changes after clicking somewhere else', () {
      sut.onDown(pointA, paint);
      sut.onUp(pointB, paint);
      sut.onPlus();
      sut.onDown(pointC, paint);
      sut.onUp(pointC, paint);
      expect(sut.vertexStack.last.vertexCenter, pointC);
      sut.onDown(pointD, paint);
      sut.onUp(pointD, paint);
      expect(sut.vertexStack.last.vertexCenter, pointD);
    });
  });
}
