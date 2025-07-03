import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/core/utils/color_utils.dart';

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

      expect(topLeft.toValue(), Colors.transparent.toValue());
      expect(topRight.toValue(), Colors.transparent.toValue());
      expect(bottomLeft.toValue(), Colors.transparent.toValue());
      expect(bottomRight.toValue(), Colors.transparent.toValue());

      await UIInteraction.selectTool(ToolData.SHAPES.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (topLeftAfter, topRightAfter, bottomLeftAfter, bottomRightAfter) =
          await UIInteraction.getSquareShapeColors();

      final currentColor = UIInteraction.getCurrentColor();
      expect(topLeftAfter.toValue(), currentColor.toValue());
      expect(topRightAfter.toValue(), currentColor.toValue());
      expect(bottomLeftAfter.toValue(), currentColor.toValue());
      expect(bottomRightAfter.toValue(), currentColor.toValue());
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[SHAPES_TOOL]: test circle shape',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectEllipseShapeTypeChip();

      final (left, top, right, bottom) =
          await UIInteraction.getEllipseShapeColors();

      expect(left.toValue(), Colors.transparent.toValue().toInt());
      expect(top.toValue(), Colors.transparent.toValue().toInt());
      expect(right.toValue(), Colors.transparent.toValue());
      expect(bottom.toValue(), Colors.transparent.toValue());

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (leftAfter, topAfter, rightAfter, bottomAfter) =
          await UIInteraction.getEllipseShapeColors();

      final currentColor = UIInteraction.getCurrentColor();

      expect(leftAfter.toValue(), currentColor.toValue());
      expect(topAfter.toValue(), currentColor.toValue());
      expect(rightAfter.toValue(), currentColor.toValue());
      expect(bottomAfter.toValue(), currentColor.toValue());
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[SHAPES_TOOL]: test ellipse shape',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      // Assuming you have a way to select ellipse, similar to circle
      await UIInteraction.selectEllipseShapeTypeChip(); 

      // Assuming getEllipseShapeColors() samples relevant points for an ellipse
      // e.g., center-left, center-top, center-right, center-bottom of the bounding box
      final (left, top, right, bottom) =
          await UIInteraction.getEllipseShapeColors();

      expect(left.toValue(), Colors.transparent.toValue());
      expect(top.toValue(), Colors.transparent.toValue());
      expect(right.toValue(), Colors.transparent.toValue());
      expect(bottom.toValue(), Colors.transparent.toValue());

      // Tap at the center to place the default ellipse
      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (leftAfter, topAfter, rightAfter, bottomAfter) =
          await UIInteraction.getEllipseShapeColors();

      final currentColor = UIInteraction.getCurrentColor();

      // For a default ellipse, these points should now have the current color
      expect(leftAfter.toValue(), currentColor.toValue());
      expect(topAfter.toValue(), currentColor.toValue());
      expect(rightAfter.toValue(), currentColor.toValue());
      expect(bottomAfter.toValue(), currentColor.toValue());
    });
  }
}
