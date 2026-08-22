import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() async => sut = ProviderScope(child: App(showOnboardingPage: false)));

  testWidgets('[CLIPPING_TOOL]: selecting clipping tool shows checkmark',
          (WidgetTester tester) async {
        UIInteraction.initialize(tester);
        await tester.pumpWidget(sut);
        await UIInteraction.createNewImage();

        expect(WidgetFinder.checkMark, findsNothing);

        await UIInteraction.selectTool(ToolData.CLIPPING.name);

        expect(WidgetFinder.checkMark, findsOneWidget);
      });

  testWidgets('[CLIPPING_TOOL]: selecting other tools hide the checkmark',
          (WidgetTester tester) async {
        UIInteraction.initialize(tester);
        await tester.pumpWidget(sut);
        await UIInteraction.createNewImage();

        expect(WidgetFinder.checkMark, findsNothing);

        await UIInteraction.selectTool(ToolData.CLIPPING.name);

        expect(WidgetFinder.checkMark, findsOneWidget);

        await UIInteraction.selectTool(ToolData.BRUSH.name);

        expect(WidgetFinder.checkMark, findsNothing);
      });
}
