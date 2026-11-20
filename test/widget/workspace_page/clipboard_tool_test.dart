import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/clipboard_tool_options.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';

import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(child: App(showOnboardingPage: false));
  });

  Future<void> selectClipboardTool(WidgetTester tester) async {
    await UIInteraction.selectTool(ToolData.CLIPBOARD.name);
    await tester.pumpAndSettle();
    expect(find.byType(ClipboardToolOptions), findsOneWidget);
  }

  testWidgets(
      '[CLIPBOARD_TOOL_OPTIONS]: initial state displays all action buttons',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await selectClipboardTool(tester);

    expect(find.widgetWithIcon(CustomActionChip, Icons.copy), findsOneWidget);
    expect(find.widgetWithIcon(CustomActionChip, Icons.content_cut),
        findsOneWidget);
    expect(find.widgetWithIcon(CustomActionChip, Icons.paste), findsOneWidget);
    expect(find.widgetWithIcon(CustomActionChip, Icons.delete_outline), findsOneWidget);
  });

  testWidgets(
      '[CLIPBOARD_TOOL]: selecting clipboard tool does not show plus or checkmark',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);

    await UIInteraction.selectTool(ToolData.CLIPBOARD.name);
    await tester.pumpAndSettle();

    expect(WidgetFinder.plusButton, findsNothing);
    expect(WidgetFinder.checkMark, findsNothing);
  });
}
