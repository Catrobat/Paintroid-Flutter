import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/canvas_state_data.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/tools/implementation/pipette_tool.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/color_changed_command.dart';

import 'pipette_tool_test.mocks.dart';

@GenerateMocks([
  CommandManager,
  CommandFactory,
  PaintProvider,
  CanvasStateProvider,
  ColorChangedCommand,
  GraphicFactory,
])
void main() {
  late PipetteTool sut;
  late MockCommandManager mockCommandManager;
  late MockCommandFactory mockCommandFactory;
  late MockPaintProvider mockPaintProvider;
  late MockCanvasStateProvider mockCanvasStateProvider;

  const Color colorA = Color(0xFF0000FF);
  const Color colorB = Color(0xFFFF0000);

  Future<ui.Image> createTestImage(int width, int height, Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint()..color = color,
    );
    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  setUp(() async {
    mockCommandManager = MockCommandManager();
    mockCommandFactory = MockCommandFactory();
    mockPaintProvider = MockPaintProvider();
    mockCanvasStateProvider = MockCanvasStateProvider();

    sut = PipetteTool(
      commandFactory: mockCommandFactory,
      commandManager: mockCommandManager,
      type: ToolType.PIPETTE,
      paintProvider: mockPaintProvider,
      canvasStateProvider: mockCanvasStateProvider,
    );

    when(mockCommandManager.undoStack).thenReturn([]);
    when(mockCommandManager.redoStack).thenReturn([]);
    when(mockCommandManager.undo()).thenReturn(null);
    when(mockCommandManager.addGraphicCommand(any)).thenReturn(null);
    final dummyCommand = MockColorChangedCommand();
    when(mockCommandManager.redo()).thenReturn(dummyCommand);

    when(mockPaintProvider.updateColor(any)).thenReturn(null);

    final image = await createTestImage(10, 10, colorB);
    final canvasStateData = CanvasStateData(
      size: const Size(10, 10),
      commandManager: mockCommandManager,
      graphicFactory: const GraphicFactory(),
      cachedImage: image,
    );
    when(mockCanvasStateProvider.currentState).thenReturn(canvasStateData);
  });

  group('PipetteTool Unit Tests', () {
    test('onDown should set _initialColor and pick color', () async {
      final initialPaint = Paint()..color = colorA;
      sut.onDown(const Offset(5, 5), initialPaint);

      await Future.delayed(const Duration(milliseconds: 100));

      verify(mockPaintProvider.updateColor(colorB)).called(1);
    });

    test('onUp should add ColorChangedCommand if color changed', () async {
      final paint = Paint()..color = colorA;

      sut.onDown(const Offset(5, 5), paint);
      await Future.delayed(const Duration(milliseconds: 50));

      final mockCommand = MockColorChangedCommand();
      when(mockCommandFactory.createColorChangedCommand(colorA, colorB, paint))
          .thenReturn(mockCommand);

      sut.onUp(const Offset(5, 5), paint);
      await Future.delayed(const Duration(milliseconds: 100));

      verify(mockCommandManager.addGraphicCommand(mockCommand)).called(1);
    });

    test('onCancel should restore initial color', () async {
      final paint = Paint()..color = colorA;

      sut.onDown(const Offset(5, 5), paint);
      await Future.delayed(const Duration(milliseconds: 50));

      sut.onCancel();

      verify(mockPaintProvider.updateColor(colorA));
    });

    test('onUndo should revert to old color', () {
      final mockCommand = MockColorChangedCommand();

      when(mockCommand.oldColor).thenReturn(colorA);
      when(mockCommand.newColor).thenReturn(colorB);
      when(mockCommandManager.undoStack).thenReturn([mockCommand]);

      sut.onUndo();

      verify(mockPaintProvider.updateColor(colorA)).called(1);
      verify(mockCommandManager.undo()).called(1);
    });

    test('onRedo should apply new color', () {
      final mockCommand = MockColorChangedCommand();

      when(mockCommand.oldColor).thenReturn(colorA);
      when(mockCommand.newColor).thenReturn(colorB);
      when(mockCommandManager.redoStack).thenReturn([mockCommand]);

      sut.onRedo();

      verify(mockPaintProvider.updateColor(colorB)).called(1);
      verify(mockCommandManager.redo()).called(1);
    });
  });
}
