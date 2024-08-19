import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? testIDStr;

  late Widget sut;

  setUp(() async => sut = ProviderScope(child: App(showOnboardingPage: false)));

  if (testID == -1 || testID == 0) {
    testWidgets('[SHAPES_TOOL]: test square shape',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      final (topLeft, topRight, bottomLeft, bottomRight) =
          await UIInteraction.getSquareShapeColors();

      expect(topLeft, Colors.transparent);
      expect(topRight, Colors.transparent);
      expect(bottomLeft, Colors.transparent);
      expect(bottomRight, Colors.transparent);

      await UIInteraction.selectTool(ToolData.SHAPES.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (topLeftAfter, topRightAfter, bottomLeftAfter, bottomRightAfter) =
          await UIInteraction.getSquareShapeColors();

      final currentColor = UIInteraction.getCurrentColor();
      expect(topLeftAfter, currentColor);
      expect(topRightAfter, currentColor);
      expect(bottomLeftAfter, currentColor);
      expect(bottomRightAfter, currentColor);
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[SHAPES_TOOL]: test circle shape',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectCircleShapeTypeChip();

      final (left, top, right, bottom) =
          await UIInteraction.getCircleShapeColors();

      expect(left, Colors.transparent);
      expect(top, Colors.transparent);
      expect(right, Colors.transparent);
      expect(bottom, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (leftAfter, topAfter, rightAfter, bottomAfter) =
          await UIInteraction.getCircleShapeColors();

      final currentColor = UIInteraction.getCurrentColor();

      expect(leftAfter, currentColor);
      expect(topAfter, currentColor);
      expect(rightAfter, currentColor);
      expect(bottomAfter, currentColor);
    });
  }
}
