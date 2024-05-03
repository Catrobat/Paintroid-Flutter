// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/draw_path_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/utils/path_with_action_history.dart';
import 'package:paintroid/core/tools/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';
import 'brush_tool_test.mocks.dart';

@GenerateMocks([
  Path,
  PathWithActionHistory,
  Offset,
  DrawPathCommand,
  CommandManager,
  CommandFactory,
  GraphicFactory,
])
void main() {
  late MockPathWithActionHistory mockPathWithActionHistory;
  late MockPath mockPath;
  late MockOffset mockOffset;
  late MockDrawPathCommand mockDrawPathCommand;
  late MockCommandManager mockCommandManager;
  late MockCommandFactory mockCommandFactory;
  late MockGraphicFactory mockGraphicFactory;

  late Offset testOffset;
  late PathWithActionHistory testPathWithActionHistory;
  late Paint testPaint;
  late Paint testPaintCopied;
  late DrawPathCommand testDrawPathCommand;

  late BrushTool sut;

  setUp(() {
    mockPathWithActionHistory = MockPathWithActionHistory();
    mockPath = MockPath();
    mockOffset = MockOffset();
    mockDrawPathCommand = MockDrawPathCommand();
    mockCommandManager = MockCommandManager();
    mockCommandFactory = MockCommandFactory();
    mockGraphicFactory = MockGraphicFactory();

    testOffset = const Offset(12, 13);
    testPathWithActionHistory = PathWithActionHistory();
    testPaint = Paint();
    testPaintCopied = Paint();
    testDrawPathCommand = DrawPathCommand(testPathWithActionHistory, testPaint);

    sut = BrushTool(
      paint: testPaint,
      commandManager: mockCommandManager,
      commandFactory: mockCommandFactory,
      graphicFactory: mockGraphicFactory,
    );
  });

  group('On tap down event', () {
    test('Should create one DrawPathCommand with a new Path', () {
      when(mockGraphicFactory.createPathWithActionHistory())
          .thenReturn(testPathWithActionHistory);
      when(mockGraphicFactory.copyPaint(testPaint)).thenReturn(testPaintCopied);
      when(mockCommandFactory.createDrawPathCommand(any, any))
          .thenReturn(testDrawPathCommand);

      sut.onDown(testOffset);
      verify(mockGraphicFactory.createPathWithActionHistory()).called(1);
      verify(mockGraphicFactory.copyPaint(testPaint)).called(1);
      verify(mockCommandFactory.createDrawPathCommand(
              testPathWithActionHistory, testPaintCopied))
          .called(1);
      verifyNoMoreInteractions(mockCommandFactory);
      verifyNoMoreInteractions(mockGraphicFactory);
    });

    test('Should move Path to point supplied in event', () {
      when(mockGraphicFactory.createPathWithActionHistory())
          .thenReturn(mockPathWithActionHistory);
      when(mockGraphicFactory.copyPaint(testPaint)).thenReturn(testPaintCopied);
      when(mockPathWithActionHistory.moveTo(testOffset.dx, testOffset.dy))
          .thenReturn(null);
      when(mockCommandFactory.createDrawPathCommand(any, any))
          .thenReturn(testDrawPathCommand);
      sut.onDown(testOffset);
      verify(mockPathWithActionHistory.moveTo(testOffset.dx, testOffset.dy))
          .called(1);
      verifyNoMoreInteractions(mockPathWithActionHistory);
    });

    test('Should not interact with DrawPathCommand', () {
      when(mockGraphicFactory.createPathWithActionHistory())
          .thenReturn(testPathWithActionHistory);
      when(mockGraphicFactory.copyPaint(testPaint)).thenReturn(testPaintCopied);
      when(mockCommandFactory.createDrawPathCommand(any, any))
          .thenReturn(mockDrawPathCommand);
      sut.onDown(testOffset);
      verifyZeroInteractions(mockDrawPathCommand);
    });
  });

  group('On drag event', () {
    test('Should not add DrawPathCommand to CommandManager', () {
      sut.pathToDraw = testPathWithActionHistory;
      sut.onDrag(testOffset);
      verifyZeroInteractions(mockCommandManager);
      verifyZeroInteractions(mockCommandFactory);
    });

    test('Should extend Path to coordinate passed in event', () {
      sut.pathToDraw = mockPathWithActionHistory;
      when(mockPathWithActionHistory.lineTo(testOffset.dx, testOffset.dy))
          .thenReturn(null);
      sut.onDrag(testOffset);
      verify(mockPathWithActionHistory.lineTo(testOffset.dx, testOffset.dy))
          .called(1);
      verifyNoMoreInteractions(mockPathWithActionHistory);
    });
  });

  group('On tap up event', () {
    test('Should not interact with coordinate', () {
      sut.pathToDraw = testPathWithActionHistory;
      sut.onUp(mockOffset);
      verifyZeroInteractions(mockOffset);
    });

    test('Should not add DrawPathCommand to CommandManager', () {
      sut.pathToDraw = testPathWithActionHistory;
      sut.onUp(null);
      verifyZeroInteractions(mockCommandManager);
      verifyZeroInteractions(mockCommandFactory);
    });

    test('Should close Path if bound size is zero', () {
      sut.pathToDraw = mockPathWithActionHistory;
      when(mockPathWithActionHistory.path).thenReturn(mockPath);
      when(mockPath.getBounds()).thenReturn(Rect.zero);
      sut.onUp(null);
      verifyInOrder([
        mockPathWithActionHistory.path,
        mockPath.getBounds(),
        mockPathWithActionHistory.close()
      ]);
      verifyNoMoreInteractions(mockPathWithActionHistory);
    });
  });

  test('Should return Brush as ToolType', () {
    expect(sut.type, ToolType.BRUSH);
  });
}
