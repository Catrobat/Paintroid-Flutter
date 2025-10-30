import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';

import '../utils/canvas_positions.dart';
import '../utils/ui_interaction.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? testIDStr;

  late Widget sut;

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  if (testID == -1 || testID == 0) {
    testWidgets('[WATERCOLOR_TOOL]: drawing a point',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.blue);
      await UIInteraction.selectTool(ToolData.WATERCOLOR.name);

      var initialColor = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(initialColor.toARGB32(), Colors.transparent.toARGB32());

      await UIInteraction.tapAt(CanvasPosition.center);
      await tester.pumpAndSettle();

      var drawnColor = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(drawnColor.toARGB32() != Colors.transparent.toARGB32(), true);
      expect(drawnColor.b > drawnColor.r && drawnColor.b > drawnColor.g, true,
          reason: 'Pixel should have a blue tint');
      expect(drawnColor.a > 0, true,
          reason: 'Pixel alpha should be greater than 0');
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[WATERCOLOR_TOOL]: drawing a line with drag',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.green);
      await UIInteraction.selectTool(ToolData.WATERCOLOR.name);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );
      await tester.pumpAndSettle();

      var drawnColor = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(drawnColor.toARGB32() != Colors.transparent.toARGB32(), true);
      expect(drawnColor.a > 0, true,
          reason: 'Pixel alpha should be greater than 0');
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[WATERCOLOR_TOOL]: undo and redo drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.purple);
      await UIInteraction.selectTool(ToolData.WATERCOLOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      await tester.pumpAndSettle();

      var drawnColor = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(drawnColor.toARGB32() != Colors.transparent.toARGB32(), true);

      await UIInteraction.clickUndo();
      await tester.pumpAndSettle();

      var colorAfterUndo = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(colorAfterUndo.toARGB32(), Colors.transparent.toARGB32());

      await UIInteraction.clickRedo();
      await tester.pumpAndSettle();

      var colorAfterRedo = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(colorAfterRedo.toARGB32() != Colors.transparent.toARGB32(), true);
      expect(colorAfterRedo.a, greaterThan(0));
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[WATERCOLOR_TOOL]: drawing multiple points',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.orange);
      await UIInteraction.selectTool(ToolData.WATERCOLOR.name);

      await UIInteraction.tapAt(CanvasPosition.topLeft);
      await tester.pumpAndSettle();
      await UIInteraction.tapAt(CanvasPosition.topRight);
      await tester.pumpAndSettle();
      await UIInteraction.tapAt(CanvasPosition.bottomLeft);
      await tester.pumpAndSettle();
      await UIInteraction.tapAt(CanvasPosition.bottomRight);
      await tester.pumpAndSettle();

      var colorTopLeft = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.top,
      );
      expect(colorTopLeft.toARGB32() != Colors.transparent.toARGB32(), true);

      var colorTopRight = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.top,
      );
      expect(colorTopRight.toARGB32() != Colors.transparent.toARGB32(), true);

      var colorBottomLeft = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.bottom,
      );
      expect(colorBottomLeft.toARGB32() != Colors.transparent.toARGB32(), true);

      var colorBottomRight = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
      );
      expect(
          colorBottomRight.toARGB32() != Colors.transparent.toARGB32(), true);
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[WATERCOLOR_TOOL]: drawing a line over another line',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.WATERCOLOR.name);
      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );
      await tester.pumpAndSettle();

      var colorOfFirstLine = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(colorOfFirstLine.toARGB32() != Colors.transparent.toARGB32(), true,
          reason: 'First line should be visible');

      UIInteraction.setColor(Colors.red);
      await UIInteraction.dragFromTo(
        CanvasPosition.topRight,
        CanvasPosition.bottomLeft,
      );
      await tester.pumpAndSettle();

      var colorAfterSecondLine = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );

      expect(colorAfterSecondLine.toARGB32() != Colors.transparent.toARGB32(),
          true,
          reason: 'Second line should be visible');
      expect(
          colorAfterSecondLine.toARGB32() != colorOfFirstLine.toARGB32(), true,
          reason: 'Color should change after drawing red over black');
      expect(colorAfterSecondLine.r > colorOfFirstLine.r, true,
          reason: 'Red component should increase');
    });
  }
}
