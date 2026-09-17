import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/advanced_settings_panel_visibility_provider.dart';
import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/advanced_settings_panel.dart';

void main() {
  group('AdvancedSettingsPanel Widget Tests', () {
    late ProviderContainer container;

    Widget buildSut() {
      return UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: AdvancedSettingsPanel()),
        ),
      );
    }

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    testWidgets('should render Antialiasing and Smoothing switches', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSut());
      await tester.pumpAndSettle();

      expect(find.text('Antialiasing'), findsOneWidget);
      expect(find.text('Smoothing'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(2));
    });

    testWidgets('toggling a switch updates advancedSettingsProvider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSut());
      await tester.pumpAndSettle();

      expect(
        container.read(advancedSettingsProvider).isAntialiasingEnabled,
        isTrue,
      );
      await tester.tap(find.text('Antialiasing'));
      await tester.pumpAndSettle();
      expect(
        container.read(advancedSettingsProvider).isAntialiasingEnabled,
        isFalse,
      );
    });

    testWidgets('tapping close hides the panel via the visibility provider', (
      WidgetTester tester,
    ) async {
      container.read(advancedSettingsPanelVisibilityProvider.notifier).show();
      await tester.pumpWidget(buildSut());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(
        container.read(advancedSettingsPanelVisibilityProvider),
        isFalse,
      );
    });
  });
}
