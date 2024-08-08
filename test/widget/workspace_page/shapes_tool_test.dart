import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() async => sut = ProviderScope(child: App(showOnboardingPage: false)));

  testWidgets('[SHAPES_TOOL]: selecting shapes tool shows checkmark',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await UIInteraction.selectTool(ToolData.SHAPES.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsOneWidget);
  });

  testWidgets('[SHAPES_TOOL]: selecting other tool hides plus and checkmark',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await UIInteraction.selectTool(ToolData.SHAPES.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsOneWidget);

    await UIInteraction.selectTool(ToolData.BRUSH.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);
  });
}
