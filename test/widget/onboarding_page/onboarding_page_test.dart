import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_app_bar.dart';
import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_bottom_nav_bar.dart';
import 'package:paintroid/ui/pages/onboarding_page/onboarding_page.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import '../../utils/test_utils.dart';

void main() {
  late Widget sut;
  late AppLocalizations localizations;
  List<String> descriptions = [];
  
  List<String> titles = [];

  setUp(() {
    final lightTheme = LightPaintroidThemeData();
    final darkTheme = DarkPaintroidThemeData();

    sut = ProviderScope(
      overrides: [
        IDeviceService.sizeProvider
            .overrideWithValue(TestConstants.standardDeviceSize),
      ],
      child: PaintroidTheme(
        lightTheme: lightTheme,
        darkTheme: darkTheme,
        child: MaterialApp(
          theme: lightTheme.materialThemeData,
          darkTheme: darkTheme.materialThemeData,
          home: const OnboardingPage(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  });

  Future<void> initializeAppAndLocalizations(WidgetTester tester) async {
    final appBarFinder = find.byType(AppBar);
    if (tester.any(appBarFinder)) {
      localizations = AppLocalizations.of(tester.element(find.byType(OnboardingPage)));
      return;
    }

    final mainAppFinder = find.byType(MaterialApp);
    if (tester.any(mainAppFinder)) {
      localizations = AppLocalizations.of(tester.element(find.byType(OnboardingPage)));
      return;
    }

    expect(false, isTrue,
        reason:
            'Localizations not found. Ensure MaterialApp or AppBar is present.');
  }


  testWidgets(
    'screen1 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      expect(find.text(localizations.welcomeToPocketPaint), findsOneWidget);
      expect(
        find.text(localizations.introWelcomeText),
        findsOneWidget,
      );
      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text(localizations.next.toUpperCase()), findsOneWidget);
      expect(find.text(localizations.skip.toUpperCase()), findsOneWidget);
    },
  );

  testWidgets(
    'screen2 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      final nextButton = find.text(localizations.next.toUpperCase());
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.morePossibilities), findsOneWidget);
      expect(
        find.text(localizations.introPossibilitiesText),
        findsOneWidget,
      );

      expect(find.byType(OnboardingPageAppBar), findsOneWidget);

      expect(find.byKey(const Key('undoButton')), findsOneWidget);
      final undoButton = find.byKey(const Key('undoButton'));
      await tester.tap(undoButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.buttonUndo), findsOneWidget);
      expect(find.text(localizations.helpContentUndo), findsOneWidget);

      expect(find.byKey(const Key('redoButton')), findsOneWidget);
      final redoButton = find.byKey(const Key('redoButton'));
      await tester.tap(redoButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.buttonRedo), findsOneWidget);
      expect(find.text(localizations.helpContentRedo), findsOneWidget);

      expect(find.byType(OnboardingPageBottomNavigationBar), findsOneWidget);

      expect(find.text(localizations.bottomNavigationTools), findsOneWidget);
      final toolsButton = find.text(localizations.bottomNavigationTools);
      await tester.tap(toolsButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.dialogToolsTitle), findsNWidgets(2));
      expect(find.text(localizations.introBottomNavigationToolsDescription), findsOneWidget);

      expect(find.text(localizations.bottomNavigationCurrent), findsOneWidget);
      final currentButton = find.text(localizations.bottomNavigationCurrent);
      await tester.tap(currentButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.bottomNavigationCurrent), findsNWidgets(2));
      expect(find.text(localizations.introBottomNavigationCurrentDescription),
          findsOneWidget);

      expect(find.text(localizations.bottomNavigationColor), findsOneWidget);
      final colorButton = find.text(localizations.bottomNavigationColor);
      await tester.tap(colorButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.bottomNavigationColor), findsNWidgets(2));
      expect(
          find.text(localizations.introBottomNavigationColorDescription),
          findsOneWidget);

      expect(find.text(localizations.bottomNavigationLayers), findsOneWidget);
      final layersButton = find.text(localizations.bottomNavigationLayers);
      await tester.tap(layersButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.layersTitle), findsNWidgets(2));
      expect(find.text(localizations.introBottomNavigationLayersDescription),
          findsOneWidget);

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text(localizations.next.toUpperCase()), findsOneWidget);
      expect(find.text(localizations.skip.toUpperCase()), findsOneWidget);
    },
  );

  testWidgets(
    'screen3 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      final nextButton = find.text(localizations.next.toUpperCase());
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.dialogToolsTitle), findsOneWidget);
      expect(find.text(localizations.introToolMoreInformation), findsOneWidget);

      expect(find.byType(OnboardingPageAppBar), findsNothing);

      expect(find.byType(OnboardingPageBottomNavigationBar), findsNWidgets(4));
      
      titles = [
        localizations.buttonBrush, 
        localizations.buttonHand,
        localizations.buttonEraser,
        localizations.buttonLine,
        localizations.buttonShape,
        localizations.buttonFill,
        localizations.buttonSprayCan,
        localizations.buttonCursor,
        localizations.buttonText,
        localizations.buttonClipboard,
        localizations.buttonTransform,
        localizations.buttonImportImage,
        localizations.buttonPipette,
        localizations.buttonWatercolor,
        localizations.buttonSmudge,
        localizations.buttonClip
      ];

      descriptions = [
        localizations.helpContentBrush, 
        localizations.helpContentHand,
        localizations.helpContentEraser,
        localizations.helpContentLine,
        localizations.helpContentShape,
        localizations.helpContentFill,
        localizations.helpContentSprayCan,
        localizations.helpContentCursor,
        localizations.helpContentText,
        localizations.helpContentClipboard,
        localizations.helpContentTransform,
        localizations.helpContentImportPng,
        localizations.helpContentEyedropper,
        localizations.helpContentWatercolor,
        localizations.helpContentSmudge,
        localizations.helpContentClip
      ];

      for (int i = 0; i < 16; i++) {
        expect(find.text(titles[i]), findsOneWidget);
        final button = find.text(titles[i]);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text(titles[i]), findsNWidgets(2));
        expect(find.text(descriptions[i]), findsOneWidget);
      }

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text(localizations.next.toUpperCase()), findsOneWidget);
      expect(find.text(localizations.skip.toUpperCase()), findsOneWidget);
    },
  );

  testWidgets(
    'screen4 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      final nextButton = find.text(localizations.next.toUpperCase());
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.landscape), findsOneWidget);
      expect(
          find.text(localizations.introLandscapeText),
          findsOneWidget);

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text(localizations.next.toUpperCase()), findsOneWidget);
      expect(find.text(localizations.skip.toUpperCase()), findsOneWidget);
    },
  );

  testWidgets(
    'screen5 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      final nextButton = find.text(localizations.next.toUpperCase());
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text(localizations.enjoyPocketPaint), findsOneWidget);
      expect(find.text(localizations.introGetStarted),
          findsOneWidget);

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text(localizations.next.toUpperCase()), findsNothing);
      expect(find.text(localizations.skip.toUpperCase()), findsNothing);
      expect(find.text(localizations.letsGo.toUpperCase()), findsOneWidget);
    },
  );
}
