// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Project imports:
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/theme/theme.dart';
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final lightTheme = LightPaintroidThemeData();
  final darkTheme = DarkPaintroidThemeData();

  testWidgets(
    'Pixel value changes after drawing and erasing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            IDeviceService.sizeProvider
                .overrideWith((ref) => Future.value(const Size(600, 600)))
          ],
          child: PaintroidTheme(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: MaterialApp(
              theme: lightTheme.materialThemeData,
              darkTheme: darkTheme.materialThemeData,
              home: const WorkspacePage(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
            ),
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
