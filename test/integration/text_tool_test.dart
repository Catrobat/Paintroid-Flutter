import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import '../../test/utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Widget sut;

  setUp(() async {
    sut = ProviderScope(child: App(showOnboardingPage: false));
  });

  group('[TEXT_TOOL] Integration Tests', () {
   
  testWidgets('should add text to canvas when text is entered and confirmed',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.TEXT.name);

      final center = tester.getCenter(find.byType(App));
      await tester.tapAt(center);

      const testText = 'Test Text';
      await tester.enterText(find.byKey(const ValueKey('text_tool_input')), testText);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('text_tool_input')));
      await tester.pumpAndSettle();

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('should update text properties when modified',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.TEXT.name);

      final container = ProviderScope.containerOf(tester.element(find.byType(App)));
      final textOptionsNotifier = container.read(textToolOptionsStateProvider.notifier);
      
      textOptionsNotifier.setFontSize(40);
      await tester.pumpAndSettle();

      final textState = container.read(textToolOptionsStateProvider);
      expect(textState.fontSize, 40);
    });

     testWidgets('should toggle text styles correctly',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.TEXT.name);

      final container = ProviderScope.containerOf(tester.element(find.byType(App)));
      final textOptionsNotifier = container.read(textToolOptionsStateProvider.notifier);

      textOptionsNotifier.toggleUnderline();
      await tester.pumpAndSettle();
      expect(container.read(textToolOptionsStateProvider).isUnderline, true);

      textOptionsNotifier.toggleItalic();
      await tester.pumpAndSettle();
      expect(container.read(textToolOptionsStateProvider).isItalic, true);

      textOptionsNotifier.toggleBold();
      await tester.pumpAndSettle();
      expect(container.read(textToolOptionsStateProvider).isBold, true);
    });


  testWidgets('should change font family when selected',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.TEXT.name);

      final container = ProviderScope.containerOf(tester.element(find.byType(App)));
      final textOptionsNotifier = container.read(textToolOptionsStateProvider.notifier);

      textOptionsNotifier.setFontFamily('Monospace');
      await tester.pumpAndSettle();

      final textState = container.read(textToolOptionsStateProvider);
      expect(textState.fontFamily, 'Monospace');
    });
  });
}
