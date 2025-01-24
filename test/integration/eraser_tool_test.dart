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

  setUp(() async {
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  if (testID == -1 || testID == 0) {
    testWidgets('[ERASER_TOOL]: erase one point ', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.center);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.black);

      await UIInteraction.selectTool(ToolData.ERASER.name);
      await UIInteraction.tapAt(CanvasPosition.center);

      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[ERASER_TOOL]: eraser erases multiple points',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      await UIInteraction.tapAt(CanvasPosition.topCenter);
      await UIInteraction.tapAt(CanvasPosition.bottomCenter);

      var color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.black);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.top);
      expect(color, Colors.black);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.bottom);
      expect(color, Colors.black);

      await UIInteraction.selectTool(ToolData.ERASER.name);
      await UIInteraction.tapAt(CanvasPosition.center);

      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.top);
      expect(color, Colors.black);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.bottom);
      expect(color, Colors.black);
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[ERASER_TOOL]: eraser undo and redo functionality',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.tapAt(CanvasPosition.center);
      var color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.black);

      await UIInteraction.selectTool(ToolData.ERASER.name);
      await UIInteraction.tapAt(CanvasPosition.center);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);

      await UIInteraction.clickUndo();
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.black);

      await UIInteraction.clickRedo();
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[ERASER_TOOL]: eraser does not affect empty canvas',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.ERASER.name);

      var color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.center);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[ERASER_TOOL]: eraser erases with drag gesture',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.dragFromTo(
          CanvasPosition.centerLeft, CanvasPosition.centerRight);
      var color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.black);

      await UIInteraction.selectTool(ToolData.ERASER.name);

      await UIInteraction.dragFromTo(
          CanvasPosition.center, CanvasPosition.centerRight);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.centerX, CanvasPosition.centerY);
      expect(color, Colors.transparent);
      color = await UIInteraction.getPixelColor(
          CanvasPosition.halfwayLeft, CanvasPosition.centerY);
      expect(color, Colors.black);
    });
  }
}
