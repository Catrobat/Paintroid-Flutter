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

      expect(topLeft.toARGB32(), Colors.transparent.toARGB32());
      expect(topRight.toARGB32(), Colors.transparent.toARGB32());
      expect(bottomLeft.toARGB32(), Colors.transparent.toARGB32());
      expect(bottomRight.toARGB32(), Colors.transparent.toARGB32());

      await UIInteraction.selectTool(ToolData.SHAPES.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (topLeftAfter, topRightAfter, bottomLeftAfter, bottomRightAfter) =
          await UIInteraction.getSquareShapeColors();

      final currentColor = UIInteraction.getCurrentColor();
      expect(topLeftAfter.toARGB32(), currentColor.toARGB32());
      expect(topRightAfter.toARGB32(), currentColor.toARGB32());
      expect(bottomLeftAfter.toARGB32(), currentColor.toARGB32());
      expect(bottomRightAfter.toARGB32(), currentColor.toARGB32());
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[SHAPES_TOOL]: test ellipse shape', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectShapesToolShapeType(
        WidgetFinder.ellipseShapeTypeChip,
      );

      final (left, top, right, bottom) =
          await UIInteraction.getEllipseShapeColors();

      expect(left.toARGB32(), Colors.transparent.toARGB32());
      expect(top.toARGB32(), Colors.transparent.toARGB32());
      expect(right.toARGB32(), Colors.transparent.toARGB32());
      expect(bottom.toARGB32(), Colors.transparent.toARGB32());

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final (leftAfter, topAfter, rightAfter, bottomAfter) =
          await UIInteraction.getEllipseShapeColors();

      final currentColor = UIInteraction.getCurrentColor();

      expect(leftAfter.toARGB32(), currentColor.toARGB32());
      expect(topAfter.toARGB32(), currentColor.toARGB32());
      expect(rightAfter.toARGB32(), currentColor.toARGB32());
      expect(bottomAfter.toARGB32(), currentColor.toARGB32());
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[SHAPES_TOOL]: test star shape', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectShapesToolShapeType(
        WidgetFinder.starShapeTypeChip,
      );

      final colorsBefore = await UIInteraction.getStarShapeColors();

      for (final color in colorsBefore) {
        expect(color.toARGB32(), Colors.transparent.toARGB32());
      }

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final colorsAfter = await UIInteraction.getStarShapeColors();

      final currentColor = UIInteraction.getCurrentColor();

      for (final color in colorsAfter) {
        expect(color.toARGB32(), currentColor.toARGB32());
      }
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[SHAPES_TOOL]: test heart shape', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectShapesToolShapeType(
        WidgetFinder.heartShapeTypeChip,
      );

      final colorsBefore = await UIInteraction.getHeartShapeColors();

      for (final color in colorsBefore) {
        expect(color.toARGB32(), Colors.transparent.toARGB32());
      }

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final colorsAfter = await UIInteraction.getHeartShapeColors();

      final currentColor = UIInteraction.getCurrentColor();

      for (final color in colorsAfter) {
        expect(color.toARGB32(), currentColor.toARGB32());
      }
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[SHAPES_TOOL]: test square shape - fill style',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectShapesToolShapeStyle(
        WidgetFinder.fillStyleChip,
      );

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.clickCheckmark();

      final centerColor = await UIInteraction.getCenterPixelColor();
      final expectedColor = UIInteraction.getCurrentColor();
      expect(centerColor.toARGB32(), expectedColor.toARGB32());
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[SHAPES_TOOL]: test square shape - outline style',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.SHAPES.name);
      await UIInteraction.selectShapesToolShapeStyle(
        WidgetFinder.outlineStyleChip,
      );

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final centerColor = await UIInteraction.getCenterPixelColor();
      expect(centerColor.toARGB32(), Colors.transparent.toARGB32());
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[SHAPES_TOOL]: test square shape - dashed style',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.SHAPES.name);

      final listViewFinder = find.ancestor(
        of: WidgetFinder.fillStyleChip,
        matching: find.byType(ListView),
      );
      expect(listViewFinder, findsOneWidget,
          reason: 'Could not find the ListView for shape style chips.');

      final scrollableFinder = find.descendant(
        of: listViewFinder,
        matching: find.byType(Scrollable),
      );
      expect(scrollableFinder, findsOneWidget,
          reason: 'The ListView should contain one Scrollable widget.');

      await tester.scrollUntilVisible(
        WidgetFinder.dashedStyleChip,
        -300.0,
        scrollable: scrollableFinder,
      );

      await UIInteraction.selectShapesToolShapeStyle(
        WidgetFinder.dashedStyleChip,
      );

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final centerColor = await UIInteraction.getCenterPixelColor();
      expect(centerColor.toARGB32(), Colors.transparent.toARGB32());
    });
  }

  if (testID == -1 || testID == 5) {
    testWidgets('[SHAPES_TOOL]: test square shape - fillAndDashed style',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      await UIInteraction.selectTool(ToolData.SHAPES.name);

      final listViewFinder = find.ancestor(
        of: WidgetFinder.fillStyleChip,
        matching: find.byType(ListView),
      );
      expect(listViewFinder, findsOneWidget,
          reason: 'Could not find the ListView for shape style chips.');

      final scrollableFinder = find.descendant(
        of: listViewFinder,
        matching: find.byType(Scrollable),
      );
      expect(scrollableFinder, findsOneWidget,
          reason: 'The ListView should contain one Scrollable widget.');

      await tester.scrollUntilVisible(
        WidgetFinder.fillAndDashedStyleChip,
        -500.0,
        scrollable: scrollableFinder,
      );
      await tester.pumpAndSettle();

      await UIInteraction.selectShapesToolShapeStyle(
        WidgetFinder.fillAndDashedStyleChip,
      );

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.clickCheckmark();

      final centerColor = await UIInteraction.getCenterPixelColor();
      expect(
          centerColor.toARGB32(), UIInteraction.getCurrentColor().toARGB32());
    });
  }
}
