import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l10n/l10n.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

import 'bottom_nav_bar_interactions.dart';
import 'interactive_viewer_interactions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() {
    final _lightTheme = LightPaintroidThemeData();
    final _darkTheme = DarkPaintroidThemeData();

    sut = ProviderScope(
      overrides: [
        IDeviceService.sizeProvider
            .overrideWith((ref) => Future.value(const Size(600, 600)))
      ],
      child: PaintroidTheme(
        lightTheme: _lightTheme,
        darkTheme: _darkTheme,
        child: const MaterialApp(
          home: WorkspaceScreen(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        ),
      ),
    );
  });

  testWidgets('Pan bottom left', (WidgetTester tester) async {
    await tester.pumpWidget(sut);
    await tester.pumpAndSettle();

    final bottomNavBarInteractions = BottomNavBarInteractions(tester);
    final interactiveViewerInteractions = InterActiveViewerInteractions(tester);
    await bottomNavBarInteractions.selectTool(ToolData.HAND);
    await interactiveViewerInteractions.panAndVerify(const Offset(-50, 50));
  });

  testWidgets('Pan bottom right', (WidgetTester tester) async {
    await tester.pumpWidget(sut);
    await tester.pumpAndSettle();

    final bottomNavBarInteractions = BottomNavBarInteractions(tester);
    final interactiveViewerInteractions = InterActiveViewerInteractions(tester);
    await bottomNavBarInteractions.selectTool(ToolData.HAND);
    await interactiveViewerInteractions.panAndVerify(const Offset(50, 50));
  });

  testWidgets('Pan top left', (WidgetTester tester) async {
    await tester.pumpWidget(sut);
    await tester.pumpAndSettle();

    final bottomNavBarInteractions = BottomNavBarInteractions(tester);
    final interactiveViewerInteractions = InterActiveViewerInteractions(tester);
    await bottomNavBarInteractions.selectTool(ToolData.HAND);
    await interactiveViewerInteractions.panAndVerify(const Offset(-50, -50));
  });

  testWidgets('Pan top right', (WidgetTester tester) async {
    await tester.pumpWidget(sut);
    await tester.pumpAndSettle();

    final bottomNavBarInteractions = BottomNavBarInteractions(tester);
    final interactiveViewerInteractions = InterActiveViewerInteractions(tester);
    await bottomNavBarInteractions.selectTool(ToolData.HAND);
    await interactiveViewerInteractions.panAndVerify(const Offset(50, -50));
  });
}
