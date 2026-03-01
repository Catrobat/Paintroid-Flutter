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
    testWidgets('[BRUSH_TOOL]: drawing a point', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.transparent.toValue());

      await UIInteraction.tapAt(CanvasPosition.center);

      color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[BRUSH_TOOL]: drawing a line with drag',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

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
    testWidgets('[BRUSH_TOOL]: undo and redo drawing',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.tapAt(CanvasPosition.center);

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

  if (testID == -1 || testID == 3) {
    testWidgets('[BRUSH_TOOL]: drawing multiple points',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.tapAt(CanvasPosition.topLeft);
      await UIInteraction.tapAt(CanvasPosition.topRight);
      await UIInteraction.tapAt(CanvasPosition.bottomLeft);
      await UIInteraction.tapAt(CanvasPosition.bottomRight);

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.top,
      );
      expect(color.toValue(), Colors.black.toValue());

      color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.top,
      );
      expect(color.toValue(), Colors.black.toValue());

      color = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.bottom,
      );
      expect(color.toValue(), Colors.black.toValue());

      color = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
      );
      expect(color.toValue(), Colors.black.toValue());
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[BRUSH_TOOL]: drawing a line over another line',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(Colors.black);
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.dragFromTo(
        CanvasPosition.topLeft,
        CanvasPosition.bottomRight,
      );

      var color = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(color.toValue(), Colors.black.toValue());

      UIInteraction.setColor(Colors.red);

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

  if (testID == -1 || testID == 5) {
    testWidgets('[BRUSH_TOOL]: opacity should stay stable after zoom',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();
      UIInteraction.setColor(const Color.fromARGB(96, 0, 0, 255));
      await UIInteraction.selectTool(ToolData.BRUSH.name);

      await UIInteraction.tapAt(CanvasPosition.center);

      final colorBeforeZoom = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      final alphaBeforeZoom = colorBeforeZoom.a;
      expect(alphaBeforeZoom, greaterThan(0));
      expect(alphaBeforeZoom, lessThan(255));

      final ivFinder = find.byType(InteractiveViewer);
      expect(ivFinder, findsOneWidget,
          reason: 'InteractiveViewer should be present');

      final interactiveViewer = tester.widget<InteractiveViewer>(ivFinder);
      final transformationController =
          interactiveViewer.transformationController!;

      transformationController.value = Matrix4.identity()..scale(2.0);
      await tester.pumpAndSettle();

      transformationController.value = Matrix4.identity();
      await tester.pumpAndSettle();

      final colorAfterZoom = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      final alphaAfterZoom = colorAfterZoom.a;

      expect(
        (alphaAfterZoom - alphaBeforeZoom).abs(),
        lessThanOrEqualTo(2),
        reason:
            'Alpha channel should stay stable after zoom/repaint for existing strokes',
      );
    });
  }
}
