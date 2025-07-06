import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/core/utils/color_utils.dart';

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
    testWidgets('[CURSOR_TOOL]: cursor positioning without drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[CURSOR_TOOL]: toggle cursor active with tap',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[CURSOR_TOOL]: drawing when cursor is active',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[CURSOR_TOOL]: toggle cursor off stops drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.centerLeft,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.centerRight,
        CanvasPosition.bottomRight,
      );

      color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[CURSOR_TOOL]: cursor position follows drag movement',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.center,
        CanvasPosition.topLeft,
      );

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 5) {
    testWidgets('[CURSOR_TOOL]: undo and redo with cursor drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());

      await UIInteraction.clickUndo();

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());

      await UIInteraction.clickRedo();

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 6) {
    testWidgets('[CURSOR_TOOL]: multiple cursor movements and drawings',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.center,
        CanvasPosition.topLeft,
      );
      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.topRight,
      );

      await UIInteraction.dragFromTo(
        CanvasPosition.topRight,
        CanvasPosition.bottomLeft,
      );
      await UIInteraction.dragFromTo(
        CanvasPosition.bottomLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.top,
      );
      expect(color.toValue(), Colors.black.toValue());

      color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 7) {
    testWidgets('[CURSOR_TOOL]: drawing with different colors',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      UIInteraction.setColor(Colors.black);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.bottomRight,
        CanvasPosition.topLeft,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());

      UIInteraction.setColor(Colors.red);

      await UIInteraction.tapAt(CanvasPosition.center);

      await UIInteraction.dragFromTo(
        CanvasPosition.topRight,
        CanvasPosition.bottomLeft,
      );

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.red.toValue());
    });
  }

  if (testID == -1 || testID == 8) {
    testWidgets('[CURSOR_TOOL]: inactive cursor does not interfere with touch',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.CURSOR.name);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );
      await UIInteraction.dragFromTo(
        CanvasPosition.topRight,
        CanvasPosition.bottomLeft,
      );
      await UIInteraction.dragFromTo(
        CanvasPosition.centerLeft,
        CanvasPosition.centerRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());

      color = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());

      color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());
    });
  }
}
