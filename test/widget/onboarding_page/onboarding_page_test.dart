// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_app_bar.dart';
import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_bottom_nav_bar.dart';
import 'package:paintroid/ui/pages/onboarding_page/onboarding_page.dart';

void main() {
  late Widget sut;
  final List<String> descriptions = [
    'Tap on the symbols on the bottom bar to change the color or the brush size.',
    'Move your finger to move the canvas.',
    'Remove parts of the image like with an eraser.',
    'Draw a straight line.',
    'Choose a shape and tap on the checkmark to insert the selected shape.',
    'Tap on the image to fill an area with the selected color.',
    'Move your finger on the image to create a spray can pattern.',
    'Position the cursor where you want to draw. Tap to activate the cursor. Move your finger to draw. Tap again to deactivate.',
    'Write text and format it. Resize the text box afterwards. Tap on the checkmark to insert the text on the image.',
    'Move and resize the rectangle to cover the area you want to stamp. Tap on copy or cut to select the area. Move it, then tap on paste to stamp.',
    'Use to transform the image.',
    'Import an image from the gallery to the stamp tool.',
    'Tap on the image to select a color.',
    'Similar to the brush tool with a watercolor effect. However you can also change the strength of the brush with the slider in the color menu.',
    'Move your finger on the image on different drawings to smudge them.',
    'Mark area which should not be erased.',
  ];
  final List<String> titles = [
    'Brush',
    'Hand',
    'Eraser',
    'Line',
    'Shapes',
    'Fill',
    'Spray can',
    'Cursor',
    'Text',
    'Stamp',
    'Transform',
    'Import image',
    'Pipette',
    'Watercolor',
    'Smudge',
    'Clip area',
  ];

  setUp(() {
    sut = const ProviderScope(
      child: MaterialApp(
        home: OnboardingPage(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
        ],
      ),
    );
  });

  testWidgets(
    'screen1 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      expect(find.text('Welcome To Pocket Paint'), findsOneWidget);
      expect(
        find.text(
          'With Pocket Paint there are no limits to your creativity. If you are new, start the intro, or skip it if you are already familiar with Pocket Paint.',
        ),
        findsOneWidget,
      );
      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);
    },
  );

  testWidgets(
    'screen2 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      final nextButton = find.text('NEXT');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('More possibilities'), findsOneWidget);
      expect(
        find.text(
          'Use the top bar to open the overflow menu and to undo or redo changes',
        ),
        findsOneWidget,
      );

      expect(find.byType(OnboardingPageAppBar), findsOneWidget);

      expect(find.byKey(const Key('undoButton')), findsOneWidget);
      final undoButton = find.byKey(const Key('undoButton'));
      await tester.tap(undoButton);
      await tester.pumpAndSettle();
      expect(find.text('Undo'), findsOneWidget);
      expect(find.text('Tap to undo your previous action.'), findsOneWidget);

      expect(find.byKey(const Key('redoButton')), findsOneWidget);
      final redoButton = find.byKey(const Key('redoButton'));
      await tester.tap(redoButton);
      await tester.pumpAndSettle();
      expect(find.text('Redo'), findsOneWidget);
      expect(find.text('Tap to redo an undone action.'), findsOneWidget);

      expect(find.byType(OnboardingPageBottomNavigationBar), findsOneWidget);

      expect(find.text('Tools'), findsOneWidget);
      final toolsButton = find.text('Tools');
      await tester.tap(toolsButton);
      await tester.pumpAndSettle();
      expect(find.text('Tools'), findsNWidgets(2));
      expect(find.text('Switch to the tool you want to use.'), findsOneWidget);

      expect(find.text('Current'), findsOneWidget);
      final currentButton = find.text('Current');
      await tester.tap(currentButton);
      await tester.pumpAndSettle();
      expect(find.text('Current'), findsNWidgets(2));
      expect(find.text('Shows the currently used tool and opens its options.'),
          findsOneWidget);

      expect(find.text('Color'), findsOneWidget);
      final colorButton = find.text('Color');
      await tester.tap(colorButton);
      await tester.pumpAndSettle();
      expect(find.text('Color'), findsNWidgets(2));
      expect(
          find.text(
              'Shows the currently used color and opens the color picker.'),
          findsOneWidget);

      expect(find.text('Layers'), findsOneWidget);
      final layersButton = find.text('Layers');
      await tester.tap(layersButton);
      await tester.pumpAndSettle();
      expect(find.text('Layers'), findsNWidgets(2));
      expect(find.text('Opens the layer menu and lets you manage your layers.'),
          findsOneWidget);

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);
    },
  );

  testWidgets(
    'screen3 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      final nextButton = find.text('NEXT');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Tools'), findsOneWidget);
      expect(find.text('Select the tool you want to use.'), findsOneWidget);

      expect(find.byType(OnboardingPageAppBar), findsNothing);

      expect(find.byType(OnboardingPageBottomNavigationBar), findsNWidgets(4));

      for (int i = 0; i < 16; i++) {
        expect(find.text(titles[i]), findsOneWidget);
        final button = find.text(titles[i]);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text(titles[i]), findsNWidgets(2));
        expect(find.text(descriptions[i]), findsOneWidget);
      }

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);
    },
  );

  testWidgets(
    'screen4 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      final nextButton = find.text('NEXT');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Landscape'), findsOneWidget);
      expect(
          find.text(
              'Pocket Paint also supports drawing in landscape mode to give you the best painting experience.'),
          findsOneWidget);

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);
    },
  );

  testWidgets(
    'screen5 test',
    (tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      final nextButton = find.text('NEXT');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('You are all set. Enjoy Pocket Paint.'), findsOneWidget);
      expect(find.text('Get started and create a new masterpiece.'),
          findsOneWidget);

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      expect(find.text('NEXT'), findsNothing);
      expect(find.text('SKIP'), findsNothing);
      expect(find.text("LET'S GO"), findsOneWidget);
    },
  );
}
