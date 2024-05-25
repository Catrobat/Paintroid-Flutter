// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Project imports:
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import '../../ui_interaction.dart';

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

  testWidgets('[LINE_TOOL]: first tap makes plus and checkmark appear',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.selectTool(ToolData.LINE.name);

    expect(uiInteraction.plusButton, findsNothing);
    expect(uiInteraction.checkMark, findsNothing);

    await uiInteraction.tapAt(uiInteraction.center);

    expect(uiInteraction.plusButton, findsOneWidget);
    expect(uiInteraction.checkMark, findsOneWidget);
  });

  testWidgets(
      '[LINE_TOOL]: clicking checkmark makes plus and checkmark disappear',
      (WidgetTester tester) async {
    uiInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await uiInteraction.selectTool(ToolData.LINE.name);

    expect(uiInteraction.plusButton, findsNothing);
    expect(uiInteraction.checkMark, findsNothing);

    await uiInteraction.tapAt(uiInteraction.center);

    expect(uiInteraction.plusButton, findsOneWidget);
    expect(uiInteraction.checkMark, findsOneWidget);

    await uiInteraction.clickCheckmark();

    expect(uiInteraction.plusButton, findsNothing);
    expect(uiInteraction.checkMark, findsNothing);
  });
}
