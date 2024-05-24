// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../utils/integration_test_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final interactionUtil = InteractionUtil();

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  testWidgets('[LINE_TOOL]: test line on top', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    var colorTopCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.top,
    );
    expect(colorTopCenter, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.topLeft);

    await interactionUtil.tapAt(interactionUtil.topRight);

    await interactionUtil.clickCheckmark();

    colorTopCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.top,
    );

    expect(colorTopCenter, interactionUtil.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test line on bottom', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    var colorBottomCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.bottom,
    );
    expect(colorBottomCenter, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.bottomLeft);

    await interactionUtil.tapAt(interactionUtil.bottomRight);

    await interactionUtil.clickCheckmark();

    colorBottomCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.bottom,
    );

    expect(colorBottomCenter, interactionUtil.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test vertical line', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final colorBefore = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.topCenter);

    await interactionUtil.tapAt(interactionUtil.bottomCenter);

    await interactionUtil.clickCheckmark();
    final colorAfter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );

    expect(colorAfter, interactionUtil.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test horizontal line', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final colorBefore = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.centerLeft);

    await interactionUtil.tapAt(interactionUtil.centerRight);

    await interactionUtil.clickCheckmark();
    final colorAfter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );

    expect(colorAfter, interactionUtil.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test diagonal line', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final colorBefore = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.topLeft);

    await interactionUtil.tapAt(interactionUtil.bottomRight);

    await interactionUtil.clickCheckmark();
    final colorAfter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );

    expect(colorAfter, interactionUtil.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: test multiple added lines',
      (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    var colorHalfwayTop = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.halfwayTop,
    );
    expect(colorHalfwayTop, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.halfTopLeft);
    await interactionUtil.clickPlus();

    await interactionUtil.tapAt(interactionUtil.halfTopRight);
    await interactionUtil.clickPlus();

    colorHalfwayTop = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.halfwayTop,
    );

    expect(colorHalfwayTop, interactionUtil.getCurrentColor());

    var colorHalfwayRight = await interactionUtil.getPixelColor(
      interactionUtil.halfwayRight,
      interactionUtil.centerY,
    );

    expect(colorHalfwayRight, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.halfBottomRight);
    await interactionUtil.clickPlus();

    colorHalfwayRight = await interactionUtil.getPixelColor(
      interactionUtil.halfwayRight,
      interactionUtil.centerY,
    );

    expect(colorHalfwayRight, interactionUtil.getCurrentColor());

    var colorHalfwayBottom = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.halfwayBottom,
    );

    expect(colorHalfwayBottom, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.halfBottomLeft);
    await interactionUtil.clickCheckmark();

    colorHalfwayBottom = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.halfwayBottom,
    );

    expect(colorHalfwayBottom, interactionUtil.getCurrentColor());
  });

  testWidgets('[LINE_TOOL]: tapping away from last tap changes last line',
      (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);
    interactionUtil.setColor(Colors.black);

    var actualColor = await interactionUtil.getPixelColor(
      interactionUtil.left,
      interactionUtil.centerY,
    );
    expect(actualColor, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.topLeft);
    await interactionUtil.clickPlus();

    await interactionUtil.tapAt(interactionUtil.bottomLeft);

    actualColor = await interactionUtil.getPixelColor(
      interactionUtil.left,
      interactionUtil.centerY,
    );
    expect(actualColor, Colors.black);

    await interactionUtil.tapAt(interactionUtil.topRight);

    actualColor = await interactionUtil.getPixelColor(
      interactionUtil.left,
      interactionUtil.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await interactionUtil.getPixelColor(
      interactionUtil.left,
      interactionUtil.centerY,
    );
    expect(actualColor, Colors.transparent);

    actualColor = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.top,
    );
    expect(actualColor, Colors.black);
  });

  testWidgets('[LINE_TOOL]: moving vertices changes line position',
      (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);
    interactionUtil.setColor(Colors.black);

    var actualColor = await interactionUtil.getPixelColor(
      interactionUtil.halfwayLeft,
      interactionUtil.centerY,
    );
    expect(actualColor, Colors.transparent);

    await interactionUtil.tapAt(interactionUtil.halfTopLeft);
    await interactionUtil.clickPlus();

    await interactionUtil.tapAt(interactionUtil.halfCenterLeft);
    await interactionUtil.clickPlus();

    await interactionUtil.tapAt(interactionUtil.halfBottomLeft);

    actualColor = await interactionUtil.getPixelColor(
      interactionUtil.halfwayLeft,
      interactionUtil.centerY,
    );
    expect(actualColor, Colors.black);

    await interactionUtil.dragFromTo(
      interactionUtil.halfCenterLeft,
      interactionUtil.halfCenterRight,
    );

    await interactionUtil.dragFromTo(
      interactionUtil.halfBottomLeft,
      interactionUtil.halfBottomRight,
    );

    await interactionUtil.dragFromTo(
      interactionUtil.halfTopLeft,
      interactionUtil.halfTopRight,
    );
  });
}
