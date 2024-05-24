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

  testWidgets('test line tool on top', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    var colorTopCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.top,
    );
    expect(colorTopCenter, Colors.transparent);

    await tester.tapAt(interactionUtil.topLeft);
    await tester.pump();

    await tester.tapAt(interactionUtil.topRight);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await interactionUtil.clickCheckmark();

    colorTopCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.top,
    );

    expect(colorTopCenter, interactionUtil.getCurrentColor());
  });

  testWidgets('test line tool on bottom', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    var colorBottomCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.bottom,
    );
    expect(colorBottomCenter, Colors.transparent);

    await tester.tapAt(interactionUtil.bottomLeft);
    await tester.pump();

    await tester.tapAt(interactionUtil.bottomRight);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await interactionUtil.clickCheckmark();

    colorBottomCenter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.bottom,
    );

    expect(colorBottomCenter, interactionUtil.getCurrentColor());
  });

  testWidgets('test vertical line color', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final colorBefore = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await tester.tapAt(interactionUtil.topCenter);
    await tester.pump();

    await tester.tapAt(interactionUtil.bottomCenter);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await interactionUtil.clickCheckmark();
    final colorAfter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );

    expect(colorAfter, interactionUtil.getCurrentColor());
  });

  testWidgets('test horizontal line color', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final colorBefore = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await tester.tapAt(interactionUtil.centerLeft);
    await tester.pump();

    await tester.tapAt(interactionUtil.centerRight);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await interactionUtil.clickCheckmark();
    final colorAfter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );

    expect(colorAfter, interactionUtil.getCurrentColor());
  });

  testWidgets('test diagonal line color', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final colorBefore = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );
    expect(colorBefore, Colors.transparent);

    await tester.tapAt(interactionUtil.topLeft);
    await tester.pump();

    await tester.tapAt(interactionUtil.bottomRight);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await interactionUtil.clickCheckmark();
    final colorAfter = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.centerY,
    );

    expect(colorAfter, interactionUtil.getCurrentColor());
  });

  testWidgets('test multiple lines', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    var colorHalfwayTop = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.halfwayTop,
    );
    expect(colorHalfwayTop, Colors.transparent);

    await tester.tapAt(interactionUtil.halfTopLeft);
    await tester.pump();
    await interactionUtil.clickPlus();

    await tester.tapAt(interactionUtil.halfTopRight);
    await tester.pump();
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

    await tester.tapAt(interactionUtil.halfBottomRight);
    await tester.pump();
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

    await tester.tapAt(interactionUtil.halfBottomLeft);
    await tester.pump();
    await interactionUtil.clickCheckmark();

    colorHalfwayBottom = await interactionUtil.getPixelColor(
      interactionUtil.centerX,
      interactionUtil.halfwayBottom,
    );

    expect(colorHalfwayBottom, interactionUtil.getCurrentColor());
  });
}
