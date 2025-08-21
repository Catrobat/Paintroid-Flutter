import 'package:flutter/material.dart';
import 'package:paintroid/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/core/utils/color_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/ui/pages/landing_page/landing_page.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/drawing_canvas.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/exit_fullscreen_button.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/ui/shared/dialogs/save_image_dialog.dart';

import '../utils/canvas_positions.dart';
import '../utils/ui_interaction.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? -1;

  late Widget sut;
  late AppLocalizations localizations;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  Future<void> initializeAppAndLocalizations(WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();
    await tester.pumpAndSettle();

    final appBarFinder = find.byType(AppBar);
    if (tester.any(appBarFinder)) {
      localizations = AppLocalizations.of(tester.element(appBarFinder.first));
      return;
    }

    final mainAppFinder = find.byType(MaterialApp);
    if (tester.any(mainAppFinder)) {
      localizations = AppLocalizations.of(tester.element(mainAppFinder.first));
      return;
    }

    expect(false, isTrue,
        reason:
            'Localizations not found. Ensure MaterialApp or AppBar is present.');
  }

  if (testID == -1 || testID == 0) {
    testWidgets('[OVERFLOW_MENU]: displays all menu items', (tester) async {
      await initializeAppAndLocalizations(tester);
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      for (var option in OverflowMenuOption.values) {
        late final String label;
        switch (option) {
          case OverflowMenuOption.fullscreen:
            label = localizations.fullscreen;
            break;
          case OverflowMenuOption.saveImage:
            label = localizations.saveImage;
            break;
          case OverflowMenuOption.loadImage:
            label = localizations.loadImage;
            break;
          case OverflowMenuOption.newImage:
            label = localizations.newImage;
            break;
          case OverflowMenuOption.saveProject:
            label = localizations.saveProject;
            break;
        }
        expect(find.text(label), findsOneWidget,
            reason: 'Menu item $label should be visible');
      }
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[OVERFLOW_MENU]: New Image with discard clears canvas',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.center);
      await tester.pumpAndSettle();

      final before = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(before.toValue(), isNot(Colors.transparent.a.toInt()));

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.newImage));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.discard));
      await tester.pumpAndSettle();

      final after = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(after.toValue(), Colors.transparent.a.toInt());
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[OVERFLOW_MENU]: New Image with save opens SaveImageDialog',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.center);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.newImage));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.save));
      await tester.pumpAndSettle();

      expect(find.byType(SaveImageDialog), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[OVERFLOW_MENU]: Save Image opens SaveImageDialog',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.saveImage));
      await tester.pumpAndSettle();

      expect(find.byType(SaveImageDialog), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[OVERFLOW_MENU]: Save Project opens SaveImageDialog',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.saveProject));
      await tester.pumpAndSettle();

      expect(find.byType(SaveImageDialog), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 5) {
    testWidgets(
        '[OVERFLOW_MENU]: Fullscreen hides AppBar and shows ExitFullscreenButton',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ExitFullscreenButton), findsNothing);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.fullscreen));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(ExitFullscreenButton), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 6) {
    testWidgets('[WORKSPACE_PAGE]: shows ToolOptions when not fullscreen',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ToolOptions), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 7) {
    testWidgets(
        '[WORKSPACE_PAGE - Back Button]: exits fullscreen when in fullscreen mode',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.fullscreen));
      await tester.pumpAndSettle();
      expect(find.byType(AppBar), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ExitFullscreenButton), findsNothing);
    });
  }

  if (testID == -1 || testID == 8) {
    testWidgets(
        '[WORKSPACE_PAGE - Back Button]: shows discard dialog when unsaved changes',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.center);
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text(localizations.discard), findsOneWidget);
      expect(find.text(localizations.save), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 9) {
    testWidgets(
        '[WORKSPACE_PAGE - Back Button - Discard Dialog]: navigates back when Discard pressed',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      await UIInteraction.tapAt(CanvasPosition.center);
      await tester.pumpAndSettle();

      expect(find.byType(DrawingCanvas), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.discard));
      await tester.pumpAndSettle();

      expect(find.byType(DrawingCanvas), findsNothing);
      expect(find.byType(LandingPage), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 11) {
    testWidgets(
        '[WORKSPACE_PAGE - Back Button]: navigates back directly when no unsaved changes',
        (tester) async {
      await initializeAppAndLocalizations(tester);
      final canvasFinder = find.byType(DrawingCanvas);
      expect(canvasFinder, findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(canvasFinder, findsNothing);
    });
  }
}
