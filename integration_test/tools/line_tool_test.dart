import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../../test/utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  testWidgets('[LINE_TOOL]: test line on top', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    var colorTopCenter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.top,
    );
    expect(colorTopCenter, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.topLeft);

    await UIInteraction.tapAt(CanvasPosition.topRight);

    await UIInteraction.clickCheckmark();

    colorTopCenter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.top,
    );

    expect(colorTopCenter, UIInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test line on bottom', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    var colorBottomCenter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.bottom,
    );
    expect(colorBottomCenter, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.bottomLeft);

    await UIInteraction.tapAt(CanvasPosition.bottomRight);

    await UIInteraction.clickCheckmark();

    colorBottomCenter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.bottom,
    );

    expect(colorBottomCenter, UIInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test vertical line', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.topCenter);

    await UIInteraction.tapAt(CanvasPosition.bottomCenter);

    await UIInteraction.clickCheckmark();
    final colorAfter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );

    expect(colorAfter, UIInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test horizontal line', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.centerLeft);

    await UIInteraction.tapAt(CanvasPosition.centerRight);

    await UIInteraction.clickCheckmark();
    final colorAfter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );

    expect(colorAfter, UIInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test diagonal line', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.topLeft);

    await UIInteraction.tapAt(CanvasPosition.bottomRight);

    await UIInteraction.clickCheckmark();
    final colorAfter = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );

    expect(colorAfter, UIInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test multiple added lines',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    var colorHalfwayTop = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayTop,
    );
    expect(colorHalfwayTop, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.halfTopLeft);
    await UIInteraction.clickPlus();

    await UIInteraction.tapAt(CanvasPosition.halfTopRight);
    await UIInteraction.clickPlus();

    colorHalfwayTop = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayTop,
    );

    expect(colorHalfwayTop, UIInteraction.getCurrentColor());

    var colorHalfwayRight = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(colorHalfwayRight, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.halfBottomRight);
    await UIInteraction.clickPlus();

    colorHalfwayRight = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(colorHalfwayRight, UIInteraction.getCurrentColor());

    var colorHalfwayBottom = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayBottom,
    );

    expect(colorHalfwayBottom, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.halfBottomLeft);
    await UIInteraction.clickCheckmark();

    colorHalfwayBottom = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayBottom,
    );

    expect(colorHalfwayBottom, UIInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: tapping away from last tap changes last line',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);
    UIInteraction.setColor(Colors.black);

    var actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.topLeft);
    await UIInteraction.clickPlus();

    await UIInteraction.tapAt(CanvasPosition.bottomLeft);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.black);

    await UIInteraction.tapAt(CanvasPosition.topRight);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.top,
    );
    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: moving vertices changes line position',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);
    UIInteraction.setColor(Colors.black);

    var actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.halfTopLeft);

    await UIInteraction.tapAt(CanvasPosition.halfCenterLeft);
    await UIInteraction.clickPlus();

    await UIInteraction.tapAt(CanvasPosition.halfBottomLeft);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.black);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.transparent);

    await UIInteraction.dragFromTo(
      CanvasPosition.halfTopLeft,
      CanvasPosition.halfTopRight,
    );

    await UIInteraction.dragFromTo(
      CanvasPosition.halfCenterLeft,
      CanvasPosition.halfCenterRight,
    );

    await UIInteraction.dragFromTo(
      CanvasPosition.halfBottomLeft,
      CanvasPosition.halfBottomRight,
    );

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.transparent);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: tapping vertex activates it for moving',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);
    UIInteraction.setColor(Colors.black);

    var actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    await UIInteraction.tapAt(CanvasPosition.halfTopLeft);

    await UIInteraction.tapAt(CanvasPosition.center);
    await UIInteraction.clickPlus();

    await UIInteraction.tapAt(CanvasPosition.halfBottomRight);

    await UIInteraction.tapAt(CanvasPosition.center);

    await UIInteraction.tapAt(CanvasPosition.halfCenterLeft);

    await UIInteraction.tapAt(CanvasPosition.halfBottomRight);

    await UIInteraction.tapAt(CanvasPosition.halfBottomLeft);

    actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: clicking checkmark completes line',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.halfTopLeft);

    await UIInteraction.tapAt(CanvasPosition.halfBottomLeft);

    await UIInteraction.clickCheckmark();

    await UIInteraction.tapAt(CanvasPosition.halfBottomRight);

    await UIInteraction.tapAt(CanvasPosition.halfTopRight);

    await UIInteraction.clickCheckmark();

    var actualColor = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayBottom,
    );
    expect(actualColor, Colors.transparent);
  });

  testWidgets(
      '[LINE_TOOL]: undoing while not in active line sequence rebuilds '
      'the old line sequence', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.centerLeft);
    await UIInteraction.tapAt(CanvasPosition.center);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.centerRight);

    UIInteraction.expectVertexStackLength(3);

    await UIInteraction.clickCheckmark();
    UIInteraction.expectVertexStackLength(0);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(3);
  });

  testWidgets(
      '[LINE_TOOL]: undoing when only two vertices resets the'
      'current vertexStack', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.centerLeft);
    await UIInteraction.tapAt(CanvasPosition.center);

    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(0);
  });

  testWidgets(
      '[LINE_TOOL]: undoing after completing two line sequences'
      'rebuilds each line sequence separately', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.topLeft);
    await UIInteraction.tapAt(CanvasPosition.topCenter);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.topRight);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.halfTopRight);

    UIInteraction.expectVertexStackLength(4);

    await UIInteraction.clickCheckmark();
    UIInteraction.expectVertexStackLength(0);

    await UIInteraction.tapAt(CanvasPosition.bottomLeft);
    await UIInteraction.tapAt(CanvasPosition.bottomCenter);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.bottomRight);

    UIInteraction.expectVertexStackLength(3);

    await UIInteraction.clickCheckmark();
    UIInteraction.expectVertexStackLength(0);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(3);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(0);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(4);
  });

  testWidgets(
      '[LINE_TOOL]: redoing when only two vertices restores the '
      'current vertexStack', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.centerLeft);
    await UIInteraction.tapAt(CanvasPosition.center);

    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(0);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(2);
  });

  testWidgets('[LINE_TOOL]: redoing after undo restores the last undone action',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.centerLeft);
    await UIInteraction.tapAt(CanvasPosition.center);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.centerRight);

    UIInteraction.expectVertexStackLength(3);

    await UIInteraction.clickUndo();
    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(3);
  });

  testWidgets(
      '[LINE_TOOL]: redoing after completing a line sequences '
      'restores line sequence', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.centerLeft);
    await UIInteraction.tapAt(CanvasPosition.center);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.centerRight);

    await UIInteraction.clickCheckmark();

    await UIInteraction.clickUndo(times: 3);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(3);
  });

  testWidgets(
      '[LINE_TOOL]: redoing after completing two line sequences '
      'restores each line sequence separately', (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    await UIInteraction.tapAt(CanvasPosition.topLeft);
    await UIInteraction.tapAt(CanvasPosition.topCenter);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.topRight);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.halfTopRight);

    await UIInteraction.clickCheckmark();

    await UIInteraction.tapAt(CanvasPosition.bottomLeft);
    await UIInteraction.tapAt(CanvasPosition.bottomCenter);
    await UIInteraction.clickPlus();
    await UIInteraction.tapAt(CanvasPosition.bottomRight);

    await UIInteraction.clickCheckmark();
    UIInteraction.expectVertexStackLength(0);

    await UIInteraction.clickUndo(times: 6);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(3);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(4);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(2);

    await UIInteraction.clickRedo();
    UIInteraction.expectVertexStackLength(3);
  });
}
