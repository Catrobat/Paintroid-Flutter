import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/clipboard_tool.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clipboard_command.dart';

import '../../utils/clipboard_tool_util.dart';
import 'clipboard_tool_test.mocks.dart';

@GenerateMocks(
    [BoundingBox, CommandManager, CommandFactory, ClipboardCommand, ui.Image])
void main() {
  late ClipboardTool sut;
  late MockBoundingBox boundingBox;
  late MockCommandManager commandManager;
  late MockCommandFactory commandFactory;
  late MockImage mockCopiedImage;

  const ui.Offset pointA = ui.Offset(50, 50);
  final ui.Paint paint = ui.Paint();

  setUp(() {
    boundingBox = MockBoundingBox();
    commandManager = MockCommandManager();
    commandFactory = MockCommandFactory();
    mockCopiedImage = MockImage();

    when(boundingBox.rect).thenReturn(const ui.Rect.fromLTWH(0, 0, 100, 100));
    when(boundingBox.angle).thenReturn(0.0);
    when(boundingBox.currentAction).thenReturn(BoundingBoxAction.none);

    sut = ClipboardTool(
      commandManager: commandManager,
      commandFactory: commandFactory,
      boundingBox: boundingBox,
      type: ToolType.CLIPBOARD,
    );
  });

  group('Basic behavior', () {
    test('clearClipboard sets copiedImageData to null', () async {
      final image = await ClipboardIntegrationTestUtils.createTestImage(10, 10);
      sut.copiedImageData = image;
      sut.clearClipboard();
      expect(sut.copiedImageData, isNull);
    });

    test('onDown sets _isInteracting when boundingBox action != none', () {
      when(boundingBox.determineAction(any)).thenAnswer((_) {
        when(boundingBox.currentAction).thenReturn(BoundingBoxAction.move);
      });

      sut.onDown(pointA, paint);

      verify(boundingBox.determineAction(pointA)).called(1);
      sut.onDrag(ui.Offset.zero, paint);
      verify(boundingBox.updateDrag(any)).called(1);
    });

    test('onDown does NOT set _isInteracting when boundingBox action is none',
        () {
      when(boundingBox.determineAction(any)).thenAnswer((_) {
        when(boundingBox.currentAction).thenReturn(BoundingBoxAction.none);
      });

      sut.onDown(pointA, paint);

      verify(boundingBox.determineAction(pointA)).called(1);
      sut.onDrag(ui.Offset.zero, paint);
      verifyNever(boundingBox.updateDrag(any));
    });

    test('onDrag calls boundingBox.updateDrag when interacting', () {
      when(boundingBox.currentAction).thenReturn(BoundingBoxAction.move);
      sut.onDown(pointA, paint);

      sut.onDrag(const ui.Offset(10, 10), paint);
      verify(boundingBox.updateDrag(const ui.Offset(10, 10))).called(1);
    });

    test('onDrag does NOT call boundingBox.updateDrag when not interacting',
        () {
      sut.onDrag(const ui.Offset(10, 10), paint);
      verifyNever(boundingBox.updateDrag(any));
    });

    test('onUp and onCancel end drag and reset interaction when interacting',
        () {
      when(boundingBox.currentAction).thenReturn(BoundingBoxAction.move);
      sut.onDown(pointA, paint);

      sut.onUp(pointA, paint);
      verify(boundingBox.endDrag()).called(1);
      sut.onDrag(ui.Offset.zero, paint);
      verifyNever(boundingBox.updateDrag(any));

      when(boundingBox.currentAction).thenReturn(BoundingBoxAction.move);
      sut.onDown(pointA, paint);

      sut.onCancel();
      verify(boundingBox.endDrag()).called(1);

      sut.onDrag(ui.Offset.zero, paint);
      verifyNever(boundingBox.updateDrag(any));
    });

    test('onUp does NOT call boundingBox.endDrag when not interacting', () {
      sut.onUp(pointA, paint);
      verifyNever(boundingBox.endDrag());
    });

    test('onCancel does NOT call boundingBox.endDrag when not interacting', () {
      sut.onCancel();
      verifyNever(boundingBox.endDrag());
    });
  });

  group('copy()', () {
    test('does nothing if rect has zero size', () async {
      when(boundingBox.rect).thenReturn(ui.Rect.zero);
      final img = await ClipboardIntegrationTestUtils.createTestImage(20, 20);
      await sut.copy(img);
      expect(sut.copiedImageData, isNull);
    });

    test('captures image subsection for valid rect', () async {
      final img = await ClipboardIntegrationTestUtils.createTestImage(100, 100);
      await sut.copy(img);
      expect(sut.copiedImageData, isNotNull);
      expect(sut.copiedImageData!.width, 100);
      expect(sut.copiedImageData!.height, 100);
    });
  });

  group('paste()', () {
    test('does nothing if no image copied', () async {
      sut.copiedImageData = null;
      await sut.paste(paint);
      verifyNever(
          commandFactory.createClipboardCommand(any, any, any, any, any));
      verifyNever(commandManager.addGraphicCommand(any));
    });

    test('does nothing if copiedImageData.toByteData returns null', () async {
      sut.copiedImageData = mockCopiedImage;
      when(mockCopiedImage.width).thenReturn(50);
      when(mockCopiedImage.height).thenReturn(50);
      when(mockCopiedImage.toByteData(format: ui.ImageByteFormat.png))
          .thenAnswer((_) async => null);

      await sut.paste(paint);

      verify(mockCopiedImage.toByteData(format: ui.ImageByteFormat.png))
          .called(1);
      verifyNever(
          commandFactory.createClipboardCommand(any, any, any, any, any));
      verifyNever(commandManager.addGraphicCommand(any));
    });

    test(
        'creates, prepares, and adds command when image exists and toByteData is valid',
        () async {
      final img = await ClipboardIntegrationTestUtils.createTestImage(50, 50);
      final ByteData? testByteData =
          await img.toByteData(format: ui.ImageByteFormat.png);
      expect(testByteData, isNotNull);
      final bytes = testByteData!.buffer.asUint8List();

      sut.copiedImageData = img;

      final mockCmd = MockClipboardCommand();
      when(commandFactory.createClipboardCommand(any, any, any, any, any))
          .thenReturn(mockCmd);
      when(mockCmd.prepare()).thenAnswer((_) async {});

      await sut.paste(paint);

      final expectedCenter = const ui.Offset(50.0, 50.0);
      const expectedScale = 2.0;
      const expectedAngle = 0.0;

      verify(commandFactory.createClipboardCommand(
        paint,
        bytes,
        argThat(equals(expectedCenter)),
        argThat(equals(expectedScale)),
        argThat(equals(expectedAngle)),
      )).called(1);
      verify(mockCmd.prepare()).called(1);
      verify(commandManager.addGraphicCommand(mockCmd)).called(1);
    });
  });

  test('type getter returns ToolType.CLIPBOARD', () {
    expect(sut.type, ToolType.CLIPBOARD);
  });
}
