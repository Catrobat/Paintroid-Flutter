// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/sync_command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';

void main() {
  late LineTool sut;

  const Offset pointA = Offset(0, 0);
  const Offset pointB = Offset(200, 200);
  const Offset pointC = Offset(400, 400);
  const Offset pointD = Offset(600, 600);

  setUp(() {
    sut = LineTool(
      type: ToolType.LINE,
      paint: Paint(),
      commandFactory: const CommandFactory(),
      commandManager: SyncCommandManager(commands: []),
      graphicFactory: const GraphicFactory(),
      drawingSurfaceSize: const Size(1000, 1000),
    );
  });

  group('On tap down event', () {
    test('VertexStack should have two vertices after first click', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA);
      expect(sut.vertexStack.length, 2);
    });

    test('VertexStack should have three vertices after second click', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA);
      sut.onUp(pointB);
      expect(sut.vertexStack.length, 2);
      sut.onPlus();
      sut.onDown(pointC);
      expect(sut.vertexStack.length, 3);
    });

    test('VertexStack should have four vertices after third click', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA);
      sut.onUp(pointB);
      expect(sut.vertexStack.length, 2);
      sut.onPlus();
      sut.onDown(pointC);
      expect(sut.vertexStack.length, 3);
      sut.onPlus();
      sut.onDown(pointD);
      expect(sut.vertexStack.length, 4);
    });

    test('VertexStack resets after clicking checkmark', () {
      expect(sut.vertexStack.length, 0);
      sut.onDown(pointA);
      sut.onUp(pointB);
      expect(sut.vertexStack.length, 2);
      sut.onCheckMark();
      expect(sut.vertexStack.length, 0);
    });

    test('AddNewPath is true after click plus', () {
      expect(sut.addNewPath, false);
      sut.onDown(pointA);
      sut.onUp(pointB);
      sut.onPlus();
      expect(sut.addNewPath, true);
    });

    test('Last vertex is set to movingVertex after click plus', () {
      sut.onDown(pointA);
      sut.onUp(pointB);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointC);
      sut.onUp(pointC);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointD);
      sut.onUp(pointD);
      expect(sut.movingVertex, sut.vertexStack.last);
    });

    test('Click on first vertex sets it to movingVertex', () {
      sut.onDown(pointA);
      sut.onUp(pointB);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointC);
      sut.onUp(pointC);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onDown(pointA);
      sut.onUp(pointA);
      expect(sut.movingVertex, sut.vertexStack.first);
    });

    test('Click on middle vertex sets it to movingVertex', () {
      sut.onDown(pointA);
      sut.onUp(pointB);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onPlus();
      sut.onDown(pointC);
      sut.onUp(pointC);
      expect(sut.movingVertex, sut.vertexStack.last);
      sut.onDown(pointB);
      sut.onUp(pointB);
      expect(sut.movingVertex, sut.vertexStack.elementAt(1));
    });

    test('Moving a vertex changes its vertexCenter', () {
      sut.onDown(pointA);
      sut.onUp(pointB);
      sut.onPlus();
      sut.onDown(pointC);
      sut.onUp(pointC);
      expect(sut.vertexStack.first.vertexCenter, pointA);
      sut.onDown(pointA);
      sut.onDrag(pointD);
      sut.onUp(pointD);
      expect(sut.vertexStack.first.vertexCenter, pointD);
    });

    test('Last vertexCenter changes after clicking somewhere else', () {
      sut.onDown(pointA);
      sut.onUp(pointB);
      sut.onPlus();
      sut.onDown(pointC);
      sut.onUp(pointC);
      expect(sut.vertexStack.last.vertexCenter, pointC);
      sut.onDown(pointD);
      sut.onUp(pointD);
      expect(sut.vertexStack.last.vertexCenter, pointD);
    });
  });
}
