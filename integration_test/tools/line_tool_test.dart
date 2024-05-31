// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../../test/utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final uiInteraction = UIInteraction();

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  testWidgets('[LINE_TOOL]: test line on top', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    var colorTopCenter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.top,
    );
    expect(colorTopCenter, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.topLeft);

    await uiInteraction.tapAt(CanvasPosition.topRight);

    await uiInteraction.clickCheckmark();

    colorTopCenter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.top,
    );

    expect(colorTopCenter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test line on bottom', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    var colorBottomCenter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.bottom,
    );
    expect(colorBottomCenter, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.bottomLeft);

    await uiInteraction.tapAt(CanvasPosition.bottomRight);

    await uiInteraction.clickCheckmark();

    colorBottomCenter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.bottom,
    );

    expect(colorBottomCenter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test vertical line', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.topCenter);

    await uiInteraction.tapAt(CanvasPosition.bottomCenter);

    await uiInteraction.clickCheckmark();
    final colorAfter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );

    expect(colorAfter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test horizontal line', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.centerLeft);

    await uiInteraction.tapAt(CanvasPosition.centerRight);

    await uiInteraction.clickCheckmark();
    final colorAfter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );

    expect(colorAfter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test diagonal line', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.topLeft);

    await uiInteraction.tapAt(CanvasPosition.bottomRight);

    await uiInteraction.clickCheckmark();
    final colorAfter = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );

    expect(colorAfter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test multiple added lines',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    var colorHalfwayTop = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayTop,
    );
    expect(colorHalfwayTop, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.halfTopLeft);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(CanvasPosition.halfTopRight);
    await uiInteraction.clickPlus();

    colorHalfwayTop = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayTop,
    );

    expect(colorHalfwayTop, uiInteraction.getCurrentColor());

    var colorHalfwayRight = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(colorHalfwayRight, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.halfBottomRight);
    await uiInteraction.clickPlus();

    colorHalfwayRight = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(colorHalfwayRight, uiInteraction.getCurrentColor());

    var colorHalfwayBottom = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayBottom,
    );

    expect(colorHalfwayBottom, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.halfBottomLeft);
    await uiInteraction.clickCheckmark();

    colorHalfwayBottom = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayBottom,
    );

    expect(colorHalfwayBottom, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: tapping away from last tap changes last line',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);
    uiInteraction.setColor(Colors.black);

    var actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.topLeft);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(CanvasPosition.bottomLeft);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.black);

    await uiInteraction.tapAt(CanvasPosition.topRight);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.top,
    );
    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: moving vertices changes line position',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);
    uiInteraction.setColor(Colors.black);

    var actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.halfTopLeft);

    await uiInteraction.tapAt(CanvasPosition.halfCenterLeft);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(CanvasPosition.halfBottomLeft);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.black);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.transparent);

    await uiInteraction.dragFromTo(
      CanvasPosition.halfTopLeft,
      CanvasPosition.halfTopRight,
    );

    await uiInteraction.dragFromTo(
      CanvasPosition.halfCenterLeft,
      CanvasPosition.halfCenterRight,
    );

    await uiInteraction.dragFromTo(
      CanvasPosition.halfBottomLeft,
      CanvasPosition.halfBottomRight,
    );

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.transparent);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayRight,
      CanvasPosition.centerY,
    );

    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: tapping vertex activates it for moving',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);
    uiInteraction.setColor(Colors.black);

    var actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.transparent);

    await uiInteraction.tapAt(CanvasPosition.halfTopLeft);

    await uiInteraction.tapAt(CanvasPosition.center);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(CanvasPosition.halfBottomRight);

    await uiInteraction.tapAt(CanvasPosition.center);

    await uiInteraction.tapAt(CanvasPosition.halfCenterLeft);

    await uiInteraction.tapAt(CanvasPosition.halfBottomRight);

    await uiInteraction.tapAt(CanvasPosition.halfBottomLeft);

    actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.halfwayLeft,
      CanvasPosition.centerY,
    );
    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: clicking checkmark completes line',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    await uiInteraction.tapAt(CanvasPosition.halfTopLeft);

    await uiInteraction.tapAt(CanvasPosition.halfBottomLeft);

    await uiInteraction.clickCheckmark();

    await uiInteraction.tapAt(CanvasPosition.halfBottomRight);

    await uiInteraction.tapAt(CanvasPosition.halfTopRight);

    await uiInteraction.clickCheckmark();

    var actualColor = await uiInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.halfwayBottom,
    );
    expect(actualColor, Colors.transparent);
  });
}
