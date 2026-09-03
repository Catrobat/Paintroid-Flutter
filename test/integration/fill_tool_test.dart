import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/implementation/fill_tool.dart';
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
    testWidgets('[FILL_TOOL]: test fill whole canvas',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.FILL.name);
      UIInteraction.setColor(Colors.black);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, Colors.transparent);

      await UIInteraction.tapAt(CanvasPosition.center);
      
      await tester.pumpAndSettle();

      var colorCenter = await UIInteraction.getPixelColor(CanvasPosition.centerX, CanvasPosition.centerY);
      var colorTopLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.top);
      var colorTopRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.top);
      var colorBottomLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.bottom);
      var colorBottomRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.bottom);

      expect(colorCenter, isNot(Colors.transparent));
      expect(colorTopLeft, isNot(Colors.transparent));
      expect(colorTopRight, isNot(Colors.transparent));
      expect(colorBottomLeft, isNot(Colors.transparent));
      expect(colorBottomRight, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[FILL_TOOL]: fill inside of square outside should be transparent',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      UIInteraction.setColor(Colors.black);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, Colors.transparent);

      await UIInteraction.dragFromTo(CanvasPosition.halfTopLeft, CanvasPosition.halfTopRight);

      await UIInteraction.dragFromTo(CanvasPosition.halfTopLeft, CanvasPosition.halfBottomLeft);
      await UIInteraction.dragFromTo(CanvasPosition.halfTopRight, CanvasPosition.halfBottomRight);

      await UIInteraction.dragFromTo(CanvasPosition.halfBottomLeft, CanvasPosition.halfBottomRight);
      
      await tester.pumpAndSettle();

      await UIInteraction.selectTool(ToolData.FILL.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      await tester.pumpAndSettle();

      var colorCenter = await UIInteraction.getPixelColor(CanvasPosition.centerX, CanvasPosition.centerY);
      var colorTopLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.top);
      var colorTopRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.top);
      var colorBottomLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.bottom);
      var colorBottomRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.bottom);

      expect(colorCenter, isNot(Colors.transparent));
      expect(colorTopLeft, Colors.transparent);
      expect(colorTopRight, Colors.transparent);
      expect(colorBottomLeft, Colors.transparent);
      expect(colorBottomRight, Colors.transparent);
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets('[FILL_TOOL]: fill outside of square outside be colored',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      UIInteraction.setColor(Colors.black);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, Colors.transparent);

      await UIInteraction.dragFromTo(CanvasPosition.halfTopLeft, CanvasPosition.halfTopRight);

      await UIInteraction.dragFromTo(CanvasPosition.halfTopLeft, CanvasPosition.halfBottomLeft);
      await UIInteraction.dragFromTo(CanvasPosition.halfTopRight, CanvasPosition.halfBottomRight);

      await UIInteraction.dragFromTo(CanvasPosition.halfBottomLeft, CanvasPosition.halfBottomRight);
      
      await tester.pumpAndSettle();

      await UIInteraction.selectTool(ToolData.FILL.name);

      await UIInteraction.tapAt(CanvasPosition.topLeft);
      
      await tester.pumpAndSettle();

      var colorCenter = await UIInteraction.getPixelColor(CanvasPosition.centerX, CanvasPosition.centerY);
      var colorTopLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.top);
      var colorTopRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.top);
      var colorBottomLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.bottom);
      var colorBottomRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.bottom);

      expect(colorCenter, Colors.transparent);
      expect(colorTopLeft, isNot(Colors.transparent));
      expect(colorTopRight, isNot(Colors.transparent));
      expect(colorBottomLeft, isNot(Colors.transparent));
      expect(colorBottomRight, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets('[FILL_TOOL]: fill with tolerance 100, paint over everything',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.BRUSH.name);
      UIInteraction.setColor(Colors.black);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, Colors.transparent);

      await UIInteraction.dragFromTo(CanvasPosition.halfTopLeft, CanvasPosition.halfTopRight);

      await UIInteraction.dragFromTo(CanvasPosition.halfTopLeft, CanvasPosition.halfBottomLeft);
      await UIInteraction.dragFromTo(CanvasPosition.halfTopRight, CanvasPosition.halfBottomRight);

      await UIInteraction.dragFromTo(CanvasPosition.halfBottomLeft, CanvasPosition.halfBottomRight);
      
      await tester.pumpAndSettle();

      await UIInteraction.selectTool(ToolData.FILL.name);
      UIInteraction.setColor(Colors.blue);

      const tolerance = 100.0;

      (UIInteraction.getCurrentTool() as FillTool).updateTolerance(tolerance);

      await UIInteraction.tapAt(CanvasPosition.center);

      await tester.pumpAndSettle();

      var colorCenter = await UIInteraction.getPixelColor(CanvasPosition.centerX, CanvasPosition.centerY);
      var colorTopLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.top);
      var colorTopRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.top);
      var colorBottomLeft = await UIInteraction.getPixelColor(CanvasPosition.left, CanvasPosition.bottom);
      var colorBottomRight = await UIInteraction.getPixelColor(CanvasPosition.right, CanvasPosition.bottom);
      var colorHalfwayBottomLeft = await UIInteraction.getPixelColor(CanvasPosition.halfwayLeft, CanvasPosition.halfwayBottom);

      expect(colorCenter, isNot(Colors.transparent));
      expect(colorTopLeft, isNot(Colors.transparent));
      expect(colorTopRight, isNot(Colors.transparent));
      expect(colorBottomLeft, isNot(Colors.transparent));
      expect(colorBottomRight, isNot(Colors.transparent));
      expect(colorHalfwayBottomLeft, isNot(Colors.transparent));
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[FILL_TOOL]: test fill undo and redo',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      await UIInteraction.selectTool(ToolData.FILL.name);


      await UIInteraction.tapAt(CanvasPosition.center, times: 2);

      await tester.pumpAndSettle();

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, isNot(Colors.transparent));

      await UIInteraction.clickUndo(times: 2);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, Colors.transparent);

      await UIInteraction.clickRedo(times: 2);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color, isNot(Colors.transparent));
    });
  }
}
