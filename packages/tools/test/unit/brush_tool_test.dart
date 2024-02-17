import 'dart:ui';

import 'package:command/command.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tools/tools.dart';

import 'brush_tool_test.mocks.dart';

@GenerateMocks([
  PathWithActionHistory,
  Offset,
  DrawPathCommand,
  CommandManager,
  CommandFactory,
  GraphicFactory,
])
void main() {
  late MockPathWithActionHistory mockPath;
  late MockOffset mockOffset;
  late MockDrawPathCommand mockDrawPathCommand;
  late MockCommandManager mockCommandManager;
  late MockCommandFactory mockCommandFactory;
  late MockGraphicFactory mockGraphicFactory;

  late Offset testOffset;
  late PathWithActionHistory testPath;
  late Paint testPaint;
  late Paint testPaintCopied;
  late DrawPathCommand testDrawPathCommand;

  late BrushTool sut;

  setUp(() {
    mockPath = MockPathWithActionHistory();
    mockOffset = MockOffset();
    mockDrawPathCommand = MockDrawPathCommand();
    mockCommandManager = MockCommandManager();
    mockCommandFactory = MockCommandFactory();
    mockGraphicFactory = MockGraphicFactory();

    testOffset = const Offset(12, 13);
    testPath = PathWithActionHistory();
    testPaint = Paint();
    testPaintCopied = Paint();
    testDrawPathCommand = DrawPathCommand(testPath, testPaint);

    sut = BrushTool(
      paint: testPaint,
      type: ToolType.BRUSH,
      commandManager: mockCommandManager,
      commandFactory: mockCommandFactory,
      graphicFactory: mockGraphicFactory,
    );
  });

  group('On tap down event', () {
    test('Should create one DrawPathCommand with a new Path', () {
      when(mockGraphicFactory.createPathWithActionHistory())
          .thenReturn(testPath);
      when(mockGraphicFactory.copyPaint(testPaint)).thenReturn(testPaintCopied);
      when(mockCommandFactory.createDrawPathCommand(any, any))
          .thenReturn(testDrawPathCommand);

      sut.onDown(testOffset);
      verify(mockGraphicFactory.createPathWithActionHistory()).called(1);
      verify(mockGraphicFactory.copyPaint(testPaint)).called(1);
      verify(mockCommandFactory.createDrawPathCommand(
              testPath, testPaintCopied))
          .called(1);
      verifyNoMoreInteractions(mockCommandFactory);
      verifyNoMoreInteractions(mockGraphicFactory);
    });

    test('Should move Path to point supplied in event', () {
      when(mockGraphicFactory.createPathWithActionHistory())
          .thenReturn(mockPath);
      when(mockGraphicFactory.copyPaint(testPaint)).thenReturn(testPaintCopied);
      when(mockPath.moveTo(testOffset.dx, testOffset.dy)).thenReturn(null);
      when(mockCommandFactory.createDrawPathCommand(any, any))
          .thenReturn(testDrawPathCommand);
      sut.onDown(testOffset);
      verify(mockPath.moveTo(testOffset.dx, testOffset.dy)).called(1);
      verifyNoMoreInteractions(mockPath);
    });

    test('Should not interact with DrawPathCommand', () {
      when(mockGraphicFactory.createPathWithActionHistory())
          .thenReturn(testPath);
      when(mockGraphicFactory.copyPaint(testPaint)).thenReturn(testPaintCopied);
      when(mockCommandFactory.createDrawPathCommand(any, any))
          .thenReturn(mockDrawPathCommand);
      sut.onDown(testOffset);
      verifyZeroInteractions(mockDrawPathCommand);
    });
  });

  group('On drag event', () {
    test('Should not add DrawPathCommand to CommandManager', () {
      sut.pathToDraw = testPath;
      sut.onDrag(testOffset);
      verifyZeroInteractions(mockCommandManager);
      verifyZeroInteractions(mockCommandFactory);
    });

    test('Should extend Path to coordinate passed in event', () {
      sut.pathToDraw = mockPath;
      when(mockPath.lineTo(testOffset.dx, testOffset.dy)).thenReturn(null);
      sut.onDrag(testOffset);
      verify(mockPath.lineTo(testOffset.dx, testOffset.dy)).called(1);
      verifyNoMoreInteractions(mockPath);
    });
  });

  group('On tap up event', () {
    test('Should not interact with coordinate', () {
      sut.pathToDraw = testPath;
      sut.onUp(mockOffset);
      verifyZeroInteractions(mockOffset);
    });

    test('Should not add DrawPathCommand to CommandManager', () {
      sut.pathToDraw = testPath;
      sut.onUp(null);
      verifyZeroInteractions(mockCommandManager);
      verifyZeroInteractions(mockCommandFactory);
    });

    test('Should close Path if bound size is zero', () {
      sut.pathToDraw = mockPath;
      when(mockPath.getBounds()).thenReturn(Rect.zero);
      sut.onUp(null);
      verifyInOrder([mockPath.getBounds(), mockPath.close()]);
      verifyNoMoreInteractions(mockPath);
    });
  });
}
