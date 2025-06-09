import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/text_command.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/text_tool.dart';

import 'text_tool_test.mocks.dart';

@GenerateMocks([
  CommandManager,
  CommandFactory,
  Ref,
  Canvas,
  TextCommand,
], customMocks: [
  MockSpec<BoundingBox>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCommandManager mockCommandManager;
  late MockCommandFactory mockCommandFactory;
  late MockRef mockRef;
  late MockBoundingBox mockBoundingBox;
  late TextTool textTool;
  late MockCanvas mockCanvas;
  late Paint paint;

  provideDummy<TextToolOptionsStateData>(const TextToolOptionsStateData(
    fontSize: 24,
    fontFamily: 'Roboto',
    isBold: false,
    isItalic: false,
    isUnderline: false,
  ));

  provideDummy<TextToolOptionsStateProvider>(
      MockTextToolOptionsStateNotifier());

  setUp(() {
    mockCommandManager = MockCommandManager();
    mockCommandFactory = MockCommandFactory();
    mockRef = MockRef();
    mockBoundingBox = MockBoundingBox();
    mockCanvas = MockCanvas();
    paint = Paint();

    when(mockRef.read(textToolOptionsStateProvider))
        .thenReturn(const TextToolOptionsStateData(
      fontSize: 24,
      fontFamily: 'Roboto',
      isBold: false,
      isItalic: false,
      isUnderline: false,
    ));

    when(mockBoundingBox.topLeft).thenReturn(Offset.zero);
    when(mockBoundingBox.topRight).thenReturn(Offset.zero);
    when(mockBoundingBox.bottomLeft).thenReturn(Offset.zero);
    when(mockBoundingBox.bottomRight).thenReturn(Offset.zero);
    when(mockBoundingBox.center).thenReturn(Offset.zero);

    textTool = TextTool(
      commandManager: mockCommandManager,
      commandFactory: mockCommandFactory,
      type: ToolType.TEXT,
      boundingBox: mockBoundingBox,
      ref: mockRef,
    );
  });

  test('toTextStyle converts correctly', () {
    const options = TextToolOptionsStateData(
      fontSize: 30,
      fontFamily: 'Roboto',
      isBold: true,
      isItalic: true,
      isUnderline: true,
    );
    final textStyle = options.toTextStyle(Colors.red);

    expect(textStyle.color, Colors.red);
    expect(textStyle.fontSize, 30);
    expect(textStyle.fontFamily, 'Roboto');
    expect(textStyle.fontWeight, FontWeight.bold);
    expect(textStyle.fontStyle, FontStyle.italic);
    expect(textStyle.decoration, TextDecoration.underline);
  });

  test('onDown sets active corner and enables editing', () {
    final point = Offset(10, 10);
    textTool.onDown(point, paint);

    verify(mockBoundingBox.setActiveCorner(point)).called(1);
    expect(textTool.isEditing, true);
  });

  test('onDrag updates bounding box and adjusts font size', () {
    textTool.isEditing = true;
    when(mockBoundingBox.topLeft).thenReturn(Offset(0, 0));
    when(mockBoundingBox.bottomLeft).thenReturn(Offset(0, 100));
    when(mockBoundingBox.update(any)).thenReturn(null);

    textTool.onDrag(Offset(50, 50), paint);

    verify(mockBoundingBox.update(Offset(50, 50))).called(1);
    verify(mockRef.read(textToolOptionsStateProvider))
        .called(greaterThanOrEqualTo(1));
  });

  test('onUp resets active corner', () {
    textTool.onUp(Offset.zero, paint);
    verify(mockBoundingBox.resetActiveCorner()).called(1);
  });

  test('onCancel resets text and editing state', () {
    textTool.currentText = 'Test';
    textTool.isEditing = true;

    textTool.onCancel();

    expect(textTool.currentText, '');
    expect(textTool.isEditing, false);
  });

  test('onCheckmark creates command when text is non-empty', () {
    final mockTextCommand = MockTextCommand();
    textTool.currentText = 'Hello';
    textTool.isEditing = true;

    when(mockCommandFactory.createTextCommand(
      any,
      any,
      any,
      any,
      any,
      any,
    )).thenReturn(mockTextCommand);

    textTool.onCheckmark(paint);

    verify(mockCommandManager.addGraphicCommand(mockTextCommand)).called(1);
    verify(mockCommandManager.clearRedoStack()).called(1);
    expect(textTool.currentText, '');
    expect(textTool.isEditing, false);
  });

  test('onCheckmark does nothing when text is empty', () {
    textTool.currentText = '   ';
    textTool.onCheckmark(paint);

    verifyZeroInteractions(mockCommandFactory);
    verifyZeroInteractions(mockCommandManager);
  });

  test('paintText updates bounding box and draws text', () {
    textTool.currentText = 'Test';

    textTool.paintText(mockCanvas, paint);

    verify(mockBoundingBox.updateCorners(any, any, any, any)).called(1);
    verify(mockCanvas.save()).called(1);
    verify(mockCanvas.translate(any, any)).called(1);
    verify(mockCanvas.rotate(any)).called(1);
    verify(mockCanvas.restore()).called(1);
  });

  test('drawGuides calls paintText and bounding box drawing', () {
    textTool.drawGuides(mockCanvas, paint);

    verify(mockBoundingBox.drawBoundingBox(mockCanvas)).called(1);
    verify(mockCanvas.save()).called(1);
    verify(mockCanvas.restore()).called(1);
  });

  test('onDrag handles zero height without error', () {
    textTool.isEditing = true;
    when(mockBoundingBox.topLeft).thenReturn(Offset.zero);
    when(mockBoundingBox.bottomLeft).thenReturn(Offset.zero);

    textTool.onDrag(Offset(10, 10), paint);

    verifyNever(mockRef.read(textToolOptionsStateProvider.notifier));
  });

  test('onDrag clamps fontSize between min and max', () {
    textTool.isEditing = true;
    when(mockBoundingBox.topLeft).thenReturn(Offset(0, 0));
    when(mockBoundingBox.bottomLeft).thenReturn(Offset(0, 100));
    when(mockBoundingBox.update(any)).thenReturn(null);

    final mockNotifier = MockTextToolOptionsStateNotifier();
    when(mockRef.read(textToolOptionsStateProvider.notifier))
        .thenReturn(mockNotifier);

    textTool.onDrag(Offset(0, 10000), paint);

    WidgetsBinding.instance.endOfFrame.then((_) {
      verify(mockNotifier.setFontSize(TextTool.maxFontSize)).called(1);
    });
  });

  test('copyWith creates modified instance', () {
    final newBoundingBox = MockBoundingBox();
    final newRef = MockRef();

    final copy = textTool.copyWith(
      currentText: 'New',
      isEditing: true,
      boundingBox: newBoundingBox,
      ref: newRef,
    );

    expect(copy.currentText, 'New');
    expect(copy.isEditing, true);
    expect(identical(copy.boundingBox, newBoundingBox), true);
  });
}

class MockTextToolOptionsStateNotifier extends Mock
    implements TextToolOptionsStateProvider {}
