import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import '../../utils/test_utils.dart';

void main() {
  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  group('[OVERFLOW_MENU]: Advanced Options', () {
    testWidgets(
        'Advanced Options dialog opens, shows toggles off by default, handles toggle and dismiss',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      // 1. Open overflow menu
      final overflowMenuButton = find.byIcon(Icons.more_vert);
      expect(overflowMenuButton, findsOneWidget);
      await tester.tap(overflowMenuButton);
      await tester.pumpAndSettle();

      // 2. Tap Advanced Options
      final advancedOptionsMenuItem =
          find.byKey(const ValueKey(WidgetIdentifier.advancedOptionsMenuItem));
      expect(advancedOptionsMenuItem, findsOneWidget);
      await tester.tap(advancedOptionsMenuItem);
      await tester.pumpAndSettle();

      // 3. Assert dialog is shown
      final dialog =
          find.byKey(const ValueKey(WidgetIdentifier.advancedOptionsDialog));
      expect(dialog, findsOneWidget);

      // Verify toggle controls exist
      final antialiasingSwitch =
          find.byKey(const ValueKey(WidgetIdentifier.antialiasingSwitch));
      final smoothingSwitch =
          find.byKey(const ValueKey(WidgetIdentifier.smoothingSwitch));

      expect(antialiasingSwitch, findsOneWidget);
      expect(smoothingSwitch, findsOneWidget);

      // 4. Assert defaults OFF
      expect(tester.widget<SwitchListTile>(antialiasingSwitch).value, false);
      expect(tester.widget<SwitchListTile>(smoothingSwitch).value, false);

      // 5. Toggle at least one switch
      await tester.tap(antialiasingSwitch);
      await tester.pump();

      expect(tester.widget<SwitchListTile>(antialiasingSwitch).value, true);

      // 6. Tap OK
      final okButton =
          find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionOk));
      expect(okButton, findsOneWidget);
      
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(dialog, findsNothing);

      // We use repeating pump to let the dialog out animation naturally flush
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });
  });
}
