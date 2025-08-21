import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/text_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
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
  GraphicFactory,
], customMocks: [
  MockSpec<BoundingBox>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCommandManager mockCommandManager;
  late MockCommandFactory mockCommandFactory;
  late MockBoundingBox mockBoundingBox;
  late TextTool textTool;
  late MockCanvas mockCanvas;
  late Paint paint;
  late TextToolOptionsStateData options;
  late GraphicFactory mockGraphicFactory;

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
    mockBoundingBox = MockBoundingBox();
    mockCanvas = MockCanvas();
    paint = Paint();
    mockGraphicFactory = MockGraphicFactory();
    options = const TextToolOptionsStateData(
      fontSize: 24,
      fontFamily: 'Roboto',
      isBold: false,
      isItalic: false,
      isUnderline: false,
      text: 'Hello',
      isAutoSize: true,
    );
    when(mockBoundingBox.center).thenReturn(Offset.zero);
    when(mockBoundingBox.width).thenReturn(100);
    when(mockBoundingBox.height).thenReturn(50);
    when(mockBoundingBox.angle).thenReturn(0.0);
    textTool = TextTool(
      commandManager: mockCommandManager,
      commandFactory: mockCommandFactory,
      graphicFactory: mockGraphicFactory,
      type: ToolType.TEXT,
      boundingBox: mockBoundingBox,
      options: options,
    );
  });

  test('onDown sets editing state based on bounding box action', () {
    when(mockBoundingBox.currentAction).thenReturn(BoundingBoxAction.move);
    textTool.onDown(Offset(10, 10), paint);
    expect(textTool.isEditing, true);
  });

  test('onDrag calls boundingBox.updateDrag if editing', () {
    textTool.isEditing = true;
    when(mockBoundingBox.currentAction).thenReturn(BoundingBoxAction.move);
    textTool.onDrag(Offset(20, 20), paint);
    verify(mockBoundingBox.updateDrag(Offset(20, 20))).called(1);
  });

  test('onUp disables editing and calls boundingBox.endDrag', () {
    when(mockBoundingBox.currentAction).thenReturn(BoundingBoxAction.move);
    textTool.isEditing = true;
    textTool.onUp(Offset.zero, paint);
    verify(mockBoundingBox.endDrag()).called(1);
    expect(textTool.isEditing, false);
  });

  test('onCancel disables editing and calls boundingBox.endDrag', () {
    textTool.isEditing = true;
    textTool.onCancel();
    verify(mockBoundingBox.endDrag()).called(1);
    expect(textTool.isEditing, false);
  });

  test('onCheckmark does nothing if text is empty', () {
    final emptyOptions = options.copyWith(text: '');
    textTool.options = emptyOptions;
    textTool.onCheckmark(paint);
    verifyNever(mockCommandFactory.createTextCommand(
      any,
      any,
      any,
      any,
      any,
      any,
      scaleX: anyNamed('scaleX'),
      scaleY: anyNamed('scaleY'),
    ));
  });

  test('onCheckmark adds command if text is not empty', () {
    final mockTextCommand = MockTextCommand();
    when(mockCommandFactory.createTextCommand(
      any,
      any,
      any,
      any,
      any,
      any,
      scaleX: anyNamed('scaleX'),
      scaleY: anyNamed('scaleY'),
    )).thenReturn(mockTextCommand);
    textTool.onCheckmark(paint);
    verify(mockCommandManager.addGraphicCommand(mockTextCommand)).called(1);
    verify(mockCommandManager.clearRedoStack()).called(1);
    expect(textTool.isEditing, false);
  });

  test('drawGuides calls boundingBox.drawGuides', () {
    textTool.drawGuides(mockCanvas, paint);
    verify(mockBoundingBox.drawGuides(mockCanvas));
  });

  test(
      'updateOptions triggers _resizeBoundingBoxToFitText if autoSize and text changed',
      () {
    final newOptions = options.copyWith(text: 'New text');
    textTool.updateOptions(newOptions);
    expect(textTool.options.text, 'New text');
  });

  test('drawGuides does not draw text if options.text is empty', () {
    options = options.copyWith(text: '');
    textTool.options = options;
    textTool.drawGuides(mockCanvas, paint);
  });

  test('drawGuides applies scale and rotation for non-empty text', () {
    options = options.copyWith(text: 'Test');
    textTool.options = options;
    textTool.drawGuides(mockCanvas, paint);
  });

  test('onCheckmark does not add command if text is empty', () {
    options = options.copyWith(text: '');
    textTool.options = options;
    textTool.onCheckmark(paint);
    verifyNever(mockCommandManager.addGraphicCommand(any));
  });

  test(
      'updateOptions does not resize box if only font size changes and autoSize is off',
      () {
    options = options.copyWith(isAutoSize: false);
    textTool.options = options;
    final oldWidth = textTool.boundingBox.width;
    final newOptions = options.copyWith(fontSize: options.fontSize + 10);
    textTool.updateOptions(newOptions);
    expect(textTool.boundingBox.width, oldWidth);
  });

  test(
      'updateOptions recalculates font size if text changes and autoSize is off',
      () {
    double? notifiedFontSize;
    textTool = TextTool(
      commandManager: mockCommandManager,
      commandFactory: mockCommandFactory,
      graphicFactory: mockGraphicFactory,
      type: ToolType.TEXT,
      boundingBox: mockBoundingBox,
      options: options.copyWith(isAutoSize: false),
      onUserManuallyResized: (newFontSize) {
        notifiedFontSize = newFontSize;
      },
    );
    final newOptions = options.copyWith(text: 'Bigger text', isAutoSize: false);
    textTool.updateOptions(newOptions);
    expect(notifiedFontSize, isNotNull);
  });
}

class MockTextToolOptionsStateNotifier extends Mock
    implements TextToolOptionsStateProvider {}
