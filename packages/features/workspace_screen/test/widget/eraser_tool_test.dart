// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l10n/l10n.dart';
import 'package:tools/tools.dart';

// Project imports:
import 'package:workspace_screen/workspace_screen.dart';
import 'bottom_nav_bar_interactions.dart';
import 'canvas_interactions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Pixel value changes after drawing and erasing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            IDeviceService.sizeProvider
                .overrideWith((ref) => Future.value(const Size(600, 600)))
          ],
          child: const MaterialApp(
            home: WorkspaceScreen(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final canvasInteractions = CanvasInteractions(tester);
      final bottomNavBarInteractions = BottomNavBarInteractions(tester);

      const testOffset = Offset(10, 10);

      final pixelColorBeforeErase = await canvasInteractions
          .dragFromCenter(testOffset)
          .then((_) => canvasInteractions.getPixelColor(300, 300));
      expect(pixelColorBeforeErase, isNot(equals(0)));

      await bottomNavBarInteractions.selectTool(ToolData.ERASER);

      final pixelColorAfterErase = await canvasInteractions
          .dragFromCenter(testOffset)
          .then((_) => canvasInteractions.getPixelColor(300, 300));
      expect(pixelColorAfterErase, equals(0));
    },
  );
}
