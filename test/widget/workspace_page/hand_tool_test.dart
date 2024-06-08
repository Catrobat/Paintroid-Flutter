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
