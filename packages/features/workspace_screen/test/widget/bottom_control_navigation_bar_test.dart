import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l10n/l10n.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bottom_nav_bar_interactions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Select eraser and brush tool and verify NavigationBarItem changes',
      (WidgetTester tester) async {
    const eraserToolData = ToolData.ERASER;
    const brushToolData = ToolData.BRUSH;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: WorkspaceScreen(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        ),
      ),
    );

    final bottomNavBarInteractions = BottomNavBarInteractions(tester);
    await bottomNavBarInteractions
        .selectTool(eraserToolData)
        .then((_) => _.checkActiveToolIconAndLabel(eraserToolData));

    await bottomNavBarInteractions
        .selectTool(brushToolData)
        .then((_) => _.checkActiveToolIconAndLabel(brushToolData));
  });
}
