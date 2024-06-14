// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Project imports:
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/stroke_cap_tool_option.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/stroke_width_tool_option.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/theme/theme.dart';
import '../../utils/bottom_nav_bar_interactions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const VISIBLE = 1.0;
  const INVISIBLE = 0.0;

  late Widget sut;

  setUp(() {
    final lightTheme = LightPaintroidThemeData();
    final darkTheme = DarkPaintroidThemeData();

    sut = ProviderScope(
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

  group('BottomNavBarItem.TOOLS', () {
    testWidgets(
        'Select eraser and brush tool and verify NavigationBarItem changes',
        (WidgetTester tester) async {
      const eraserToolData = ToolData.ERASER;
      const brushToolData = ToolData.BRUSH;

      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      await bottomNavBarInteractions
          .selectTool(eraserToolData)
          .then((_) => _.checkActiveToolIconAndLabel(eraserToolData));

      await bottomNavBarInteractions
          .selectTool(brushToolData)
          .then((_) => _.checkActiveToolIconAndLabel(brushToolData));
    });
  });

  group('BottomNavBarItem.CURRENT_TOOL', () {
    testWidgets('test if width tool-option is visible when starting app',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);

      final animatedOpacity = bottomNavBarInteractions
          .getAnimatedOpacityFinder(StrokeWidthToolOption);

      var animatedOpacityWidget =
          tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));
    });

    testWidgets('test if width tool-option is invisible after clicking once',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);

      final animatedOpacity = bottomNavBarInteractions
          .getAnimatedOpacityFinder(StrokeWidthToolOption);

      var animatedOpacityWidget =
          tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));

      await bottomNavBarInteractions.clickCurrentTool();

      animatedOpacityWidget = tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(INVISIBLE));
    });

    testWidgets('test if width tool-option is visible after clicking twice',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final animatedOpacity = bottomNavBarInteractions
          .getAnimatedOpacityFinder(StrokeWidthToolOption);

      var animatedOpacityWidget =
          tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));

      await bottomNavBarInteractions.clickCurrentTool();

      animatedOpacityWidget = tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(INVISIBLE));

      await bottomNavBarInteractions.clickCurrentTool();

      animatedOpacityWidget = tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));
    });

    testWidgets('test if cap tool-option is visible when starting app',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final animatedOpacity = bottomNavBarInteractions
          .getAnimatedOpacityFinder(StrokeCapToolOption);

      var animatedOpacityWidget =
          tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));
    });

    testWidgets('test if cap tool-option is invisible after clicking once',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final animatedOpacity = bottomNavBarInteractions
          .getAnimatedOpacityFinder(StrokeCapToolOption);

      var animatedOpacityWidget =
          tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));

      await bottomNavBarInteractions.clickCurrentTool();

      animatedOpacityWidget = tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(INVISIBLE));
    });

    testWidgets('test if cap tool-option is visible after clicking twice',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final animatedOpacity = bottomNavBarInteractions
          .getAnimatedOpacityFinder(StrokeCapToolOption);

      var animatedOpacityWidget =
          tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));

      await bottomNavBarInteractions.clickCurrentTool();

      animatedOpacityWidget = tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(INVISIBLE));

      await bottomNavBarInteractions.clickCurrentTool();

      animatedOpacityWidget = tester.widget<AnimatedOpacity>(animatedOpacity);
      expect(animatedOpacityWidget.opacity, equals(VISIBLE));
    });
  });
}
