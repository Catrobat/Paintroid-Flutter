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

    final TestGesture gesture =
        await tester.startGesture(interactionUtil.topLeft);
    await tester.pump();

    await gesture.moveTo(interactionUtil.topRight);
    await tester.pump();

    await gesture.up();
    await tester.pump();

    await interactionUtil.clickCheckmark();

    final pixelColor = await interactionUtil.getPixelColor(50, 30);
    expect(pixelColor, interactionUtil.getCurrentColor());
  });

  testWidgets('test line tool on top', (WidgetTester tester) async {
    interactionUtil.initialize(tester);
    await tester.pumpWidget(sut);
    await interactionUtil.selectTool(ToolData.LINE.name);

    final TestGesture gesture =
        await tester.startGesture(interactionUtil.topLeft);
    await tester.pump();

    await gesture.moveTo(interactionUtil.topRight);
    await tester.pump();

    await gesture.up();
    await tester.pump();

    await interactionUtil.clickCheckmark();

    final pixelColor = await interactionUtil.getPixelColor(50, 30);

    expect(pixelColor, interactionUtil.getCurrentColor());
  });
}
