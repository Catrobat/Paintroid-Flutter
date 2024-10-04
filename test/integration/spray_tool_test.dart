import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/implementation/spray_tool.dart';
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
    testWidgets('[SPRAY_TOOL]: test spray at center colors pixels',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SPRAY.name);

      const radius = 50.0;

      (UIInteraction.getCurrentTool() as SprayTool).updateSprayRadius(radius);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );
      expect(color, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.center, times: 10);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );

      expect(color, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[SPRAY_TOOL]: test spray at top left colors pixels',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SPRAY.name);

      const radius = 50.0;

      (UIInteraction.getCurrentTool() as SprayTool).updateSprayRadius(radius);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.top,
        radius: radius.toInt(),
      );
      expect(color, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.topLeft, times: 10);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.top,
        radius: radius.toInt(),
      );

      expect(color, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[SPRAY_TOOL]: test spray at bottom right colors pixels',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SPRAY.name);

      const radius = 50.0;

      (UIInteraction.getCurrentTool() as SprayTool).updateSprayRadius(radius);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
        radius: radius.toInt(),
      );
      expect(color, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.bottomRight, times: 10);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
        radius: radius.toInt(),
      );

      expect(color, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[SPRAY_TOOL]: test spray with drag colors pixels along path',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SPRAY.name);

      const radius = 50.0;

      (UIInteraction.getCurrentTool() as SprayTool).updateSprayRadius(radius);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );
      expect(color, Colors.transparent);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
        steps: 500,
      );

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );

      expect(color, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 5) {
    testWidgets('[SPRAY_TOOL]: test spray undo and redo',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.SPRAY.name);

      const radius = 50.0;

      (UIInteraction.getCurrentTool() as SprayTool).updateSprayRadius(radius);

      await UIInteraction.tapAt(CanvasPosition.center, times: 10);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );
      expect(color, isNot(Colors.transparent));

      await UIInteraction.clickUndo(times: 10);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );
      expect(color, Colors.transparent);

      await UIInteraction.clickRedo(times: 10);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
        radius: radius.toInt(),
      );
      expect(color, isNot(Colors.transparent));
    });
  }
}
