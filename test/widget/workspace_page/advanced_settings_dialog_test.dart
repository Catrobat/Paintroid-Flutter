import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/ui/shared/dialogs/advanced_settings_dialog.dart';

void main() {
  group('AdvancedSettingsDialog Widget Tests', () {
    testWidgets('should render Anti-aliasing and Smoothing switches', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: AdvancedSettingsDialog())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Anti-aliasing'), findsOneWidget);
      expect(find.text('Smoothing'), findsOneWidget);
      expect(find.byType(Switch), findsNWidgets(2));
    });
  });
}
