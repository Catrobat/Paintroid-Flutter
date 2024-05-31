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
  final uiInteraction = UIInteraction();

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  testWidgets('[LINE_TOOL]: selecting line tool shows plus and checkmark',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await uiInteraction.selectTool(ToolData.LINE.name);

    expect(WidgetFinder.plusButton, findsOneWidget);
    expect(WidgetFinder.checkMark, findsOneWidget);
  });

  testWidgets('[LINE_TOOL]: selecting other tool hides plus and checkmark',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.createNewImage();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await uiInteraction.selectTool(ToolData.LINE.name);

    expect(WidgetFinder.plusButton, findsOneWidget);
    expect(WidgetFinder.checkMark, findsOneWidget);

    await uiInteraction.selectTool(ToolData.BRUSH.name);

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);
  });
}
