// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../../test/ui_interaction.dart';

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
      uiInteraction.centerX,
      uiInteraction.top,
    );
    expect(colorTopCenter, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.topLeft);

    await uiInteraction.tapAt(uiInteraction.topRight);

    await uiInteraction.clickCheckmark();

    colorTopCenter = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.top,
    );

    expect(colorTopCenter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test line on bottom', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    var colorBottomCenter = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.bottom,
    );
    expect(colorBottomCenter, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.bottomLeft);

    await uiInteraction.tapAt(uiInteraction.bottomRight);

    await uiInteraction.clickCheckmark();

    colorBottomCenter = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.bottom,
    );

    expect(colorBottomCenter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test vertical line', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.topCenter);

    await uiInteraction.tapAt(uiInteraction.bottomCenter);

    await uiInteraction.clickCheckmark();
    final colorAfter = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.centerY,
    );

    expect(colorAfter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test horizontal line', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.centerLeft);

    await uiInteraction.tapAt(uiInteraction.centerRight);

    await uiInteraction.clickCheckmark();
    final colorAfter = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.centerY,
    );

    expect(colorAfter, uiInteraction.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test diagonal line', (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    final colorBefore = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.topLeft);

    await uiInteraction.tapAt(uiInteraction.bottomRight);

    await uiInteraction.clickCheckmark();
    final colorAfter = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.centerY,
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
      uiInteraction.centerX,
      uiInteraction.halfwayTop,
    );
    expect(colorHalfwayTop, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.halfTopLeft);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(uiInteraction.halfTopRight);
    await uiInteraction.clickPlus();

    colorHalfwayTop = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.halfwayTop,
    );

    expect(colorHalfwayTop, uiInteraction.getCurrentColor());

    var colorHalfwayRight = await uiInteraction.getPixelColor(
      uiInteraction.halfwayRight,
      uiInteraction.centerY,
    );

    expect(colorHalfwayRight, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.halfBottomRight);
    await uiInteraction.clickPlus();

    colorHalfwayRight = await uiInteraction.getPixelColor(
      uiInteraction.halfwayRight,
      uiInteraction.centerY,
    );

    expect(colorHalfwayRight, uiInteraction.getCurrentColor());

    var colorHalfwayBottom = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.halfwayBottom,
    );

    expect(colorHalfwayBottom, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.halfBottomLeft);
    await uiInteraction.clickCheckmark();

    colorHalfwayBottom = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.halfwayBottom,
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
      uiInteraction.left,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.topLeft);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(uiInteraction.bottomLeft);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.left,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.black);

    await uiInteraction.tapAt(uiInteraction.topRight);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.left,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.left,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.top,
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
      uiInteraction.halfwayLeft,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.halfTopLeft);

    await uiInteraction.tapAt(uiInteraction.halfCenterLeft);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(uiInteraction.halfBottomLeft);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.halfwayLeft,
      uiInteraction.centerY,
    );

    expect(actualColor, Colors.black);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.halfwayRight,
      uiInteraction.centerY,
    );

    expect(actualColor, Colors.transparent);

    await uiInteraction.dragFromTo(
      uiInteraction.halfTopLeft,
      uiInteraction.halfTopRight,
    );

    await uiInteraction.dragFromTo(
      uiInteraction.halfCenterLeft,
      uiInteraction.halfCenterRight,
    );

    await uiInteraction.dragFromTo(
      uiInteraction.halfBottomLeft,
      uiInteraction.halfBottomRight,
    );

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.halfwayLeft,
      uiInteraction.centerY,
    );

    expect(actualColor, Colors.transparent);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.halfwayRight,
      uiInteraction.centerY,
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
      uiInteraction.halfwayLeft,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.transparent);

    await uiInteraction.tapAt(uiInteraction.halfTopLeft);

    await uiInteraction.tapAt(uiInteraction.center);
    await uiInteraction.clickPlus();

    await uiInteraction.tapAt(uiInteraction.halfBottomRight);

    await uiInteraction.tapAt(uiInteraction.center);

    await uiInteraction.tapAt(uiInteraction.halfCenterLeft);

    await uiInteraction.tapAt(uiInteraction.halfBottomRight);

    await uiInteraction.tapAt(uiInteraction.halfBottomLeft);

    actualColor = await uiInteraction.getPixelColor(
      uiInteraction.halfwayLeft,
      uiInteraction.centerY,
    );
    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: clicking checkmark completes line',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();
    await uiInteraction.selectTool(ToolData.LINE.name);

    await uiInteraction.tapAt(uiInteraction.halfTopLeft);

    await uiInteraction.tapAt(uiInteraction.halfBottomLeft);

    await uiInteraction.clickCheckmark();

    await uiInteraction.tapAt(uiInteraction.halfBottomRight);

    await uiInteraction.tapAt(uiInteraction.halfTopRight);

    await uiInteraction.clickCheckmark();

    var actualColor = await uiInteraction.getPixelColor(
      uiInteraction.centerX,
      uiInteraction.halfwayBottom,
    );
    expect(actualColor, Colors.transparent);
  });
}
