import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/service/device_service.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/pocket_paint.dart';

import '../utils/utils.dart';
import '../utils/interactions/interactive_viewer_interactions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() {
    sut = ProviderScope(
      overrides: [
        IDeviceService.sizeProvider
            .overrideWith((ref) => Future.value(const Size(600, 600)))
      ],
      child: const MaterialApp(
        home: PocketPaint(),
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
