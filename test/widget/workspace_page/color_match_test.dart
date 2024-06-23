// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/theme/data/dark_paintroid_theme_data.dart';
import 'package:paintroid/ui/theme/data/light_paintroid_theme_data.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';
// Project imports:
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut1, sut2;

  setUp(() async {
    sut1 = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );

    final lightTheme = LightPaintroidThemeData();
    final darkTheme = DarkPaintroidThemeData();

    sut2 =  ProviderScope(
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
    );
  });

  group('Color displays correctly', () {
    testWidgets(
        'Color and opacity remain same on two successive uses',
        (WidgetTester tester) async {
          UIInteraction.initialize(tester);
          await tester.pumpWidget(sut1);
          await UIInteraction.createNewImage();

          const blueColor = Color(0xff0073cc);

          await tester.pumpWidget(sut2);
          final bottomNavBarInteractions = BottomNavBarInteractions(tester);
          await bottomNavBarInteractions
              .selectColorWithOpacity(blueColor)
              .then((_) async {
                UIInteraction.initialize(tester);
                await tester.pumpWidget(sut1);
                await tester.tapAt(const Offset(20, 20));
                await tester.pumpAndSettle();
                await tester.tapAt(const Offset(10, 10));
                await tester.pumpAndSettle();

                final colorAtFirstTap = await UIInteraction.getPixelColor(20, 20);
                final colorAtSecondTap = await UIInteraction.getPixelColor(10, 10);

                expect(colorAtFirstTap, equals(colorAtSecondTap));
          });
    });
  });
}