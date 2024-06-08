// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Project imports:
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import '../../utils/test_utils.dart';

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

  testWidgets('[LINE_TOOL]: first tap makes plus and checkmark appear',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await UIInteraction.tapAt(CanvasPosition.center);

    expect(WidgetFinder.plusButton, findsOneWidget);
    expect(WidgetFinder.checkMark, findsOneWidget);
  });

  testWidgets(
      '[LINE_TOOL]: clicking checkmark makes plus and checkmark disappear',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await UIInteraction.selectTool(ToolData.LINE.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await UIInteraction.tapAt(CanvasPosition.center);

    expect(WidgetFinder.plusButton, findsOneWidget);
    expect(WidgetFinder.checkMark, findsOneWidget);

    await UIInteraction.clickCheckmark();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);
  });
}
