import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/pages/workspace_page/workspace_page.dart';
import 'package:paintroid/ui/theme/theme.dart';
import '../utils/bottom_nav_bar_interactions.dart';
import '../utils/interactive_viewer_interactions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? testIDStr;

  late Widget sut;

  setUp(() {
    final lightTheme = LightPaintroidThemeData();
    final darkTheme = DarkPaintroidThemeData();

    sut = ProviderScope(
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
    );
  });

  if (testID == -1 || testID == 0) {
    testWidgets(
        '[HAND_TOOL]: Pan sequentially in different directions and verify each step',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final interactiveViewerInteractions =
          InterActiveViewerInteractions(tester);
      await bottomNavBarInteractions.selectTool(ToolData.HAND);

      await interactiveViewerInteractions.panAndVerify(const Offset(100, 0));
      await interactiveViewerInteractions.panAndVerify(const Offset(0, 100));
      await interactiveViewerInteractions.panAndVerify(const Offset(-100, 0));
      await interactiveViewerInteractions.panAndVerify(const Offset(0, -100));
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[HAND_TOOL]: Tiny pans in different directions',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final interactiveViewerInteractions =
          InterActiveViewerInteractions(tester);
      await bottomNavBarInteractions.selectTool(ToolData.HAND);

      await interactiveViewerInteractions.panAndVerify(const Offset(1, 0));
      await interactiveViewerInteractions.panAndVerify(const Offset(0, 1));
      await interactiveViewerInteractions.panAndVerify(const Offset(-1, 0));
      await interactiveViewerInteractions.panAndVerify(const Offset(0, -1));
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets(
        '[HAND_TOOL]: Pan, switch tool, switch back to Hand, and continue panning',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final interactiveViewerInteractions =
          InterActiveViewerInteractions(tester);

      await bottomNavBarInteractions.selectTool(ToolData.HAND);
      await interactiveViewerInteractions.panAndVerify(const Offset(50, 50));

      await bottomNavBarInteractions.selectTool(ToolData.BRUSH);
      await tester.pumpAndSettle();

      await bottomNavBarInteractions.selectTool(ToolData.HAND);
      await tester.pumpAndSettle();

      await interactiveViewerInteractions.panAndVerify(const Offset(50, 50));
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[HAND_TOOL]: Pan by zero offset', (WidgetTester tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final interactiveViewerInteractions =
          InterActiveViewerInteractions(tester);
      await bottomNavBarInteractions.selectTool(ToolData.HAND);

      await interactiveViewerInteractions.panAndVerify(Offset.zero);
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[HAND_TOOL]: Select hand tool multiple times then pan',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final interactiveViewerInteractions =
          InterActiveViewerInteractions(tester);

      await bottomNavBarInteractions.selectTool(ToolData.HAND);
      await tester.pumpAndSettle();
      await bottomNavBarInteractions.selectTool(ToolData.HAND);
      await tester.pumpAndSettle();

      await interactiveViewerInteractions.panAndVerify(const Offset(30, -30));
    });
  }

  if (testID == -1 || testID == 5) {
    testWidgets('[HAND_TOOL]: Pan after zoom', (WidgetTester tester) async {
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final bottomNavBarInteractions = BottomNavBarInteractions(tester);
      final interactiveViewerInteractions =
          InterActiveViewerInteractions(tester);
      await bottomNavBarInteractions.selectTool(ToolData.HAND);

      final ivFinder = find.byType(InteractiveViewer);
      expect(ivFinder, findsOneWidget,
          reason: 'InteractiveViewer should be present');
      InteractiveViewer interactiveViewer = tester.widget(ivFinder);
      TransformationController controller =
          interactiveViewer.transformationController!;

      final initialMatrixBeforeZoom = Matrix4.copy(controller.value);
      final initialTranslation = initialMatrixBeforeZoom.getTranslation();

      const double zoomFactor = 2.0;
      controller.value = Matrix4.identity()
        ..scale(zoomFactor)
        ..translate(initialTranslation.x, initialTranslation.y);

      await tester.pumpAndSettle();

      expect(controller.value[0], closeTo(zoomFactor, 0.001),
          reason: 'X scale should be zoomFactor');
      expect(controller.value[5], closeTo(zoomFactor, 0.001),
          reason: 'Y scale should be zoomFactor');

      await interactiveViewerInteractions.panAndVerify(const Offset(50, 50));
    });
  }
}
