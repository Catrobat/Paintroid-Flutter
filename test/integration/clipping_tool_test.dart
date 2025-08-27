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
    testWidgets('[CLIPPING_TOOL]: clip a part of the image',
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

      await UIInteraction.selectTool(ToolData.CLIPPING.name);

      final Offset center = CanvasPosition.center;
      final Offset p1 = center + const Offset(-50, -50);
      final Offset p2 = center + const Offset(50, -50);
      final Offset p3 = center + const Offset(50, 50);
      final Offset p4 = center + const Offset(-50, 50);

      final TestGesture gesture = await tester.startGesture(p1);
      await tester.pumpAndSettle();
      await gesture.moveTo(p2);
      await tester.pumpAndSettle();
      await gesture.moveTo(p3);
      await tester.pumpAndSettle();
      await gesture.moveTo(p4);
      await tester.pumpAndSettle();
      await gesture.moveTo(p1);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();

      await UIInteraction.clickCheckmark();

      var centerColor = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(centerColor.toValue(), Colors.black.toValue());

      var topLeftColor = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.top,
      );
      expect(topLeftColor.toValue(), Colors.transparent.toValue());

      var bottomRightColor = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
      );
      expect(bottomRightColor.toValue(), Colors.transparent.toValue());
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets('[CLIPPING_TOOL]: cancel clipping',
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

      await UIInteraction.selectTool(ToolData.CLIPPING.name);

      final Offset center = CanvasPosition.center;
      final Offset p1 = center + const Offset(-50, -50);
      final Offset p2 = center + const Offset(50, -50);
      final Offset p3 = center + const Offset(50, 50);
      final Offset p4 = center + const Offset(-50, 50);

      final TestGesture gesture = await tester.startGesture(p1);
      await tester.pumpAndSettle();
      await gesture.moveTo(p2);
      await tester.pumpAndSettle();
      await gesture.moveTo(p3);
      await tester.pumpAndSettle();
      await gesture.moveTo(p4);
      await tester.pumpAndSettle();
      await gesture.moveTo(p1);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();
      await UIInteraction.clickBackButton();

      var centerColor = await UIInteraction.getPixelColor(
        CanvasPosition.centerX,
        CanvasPosition.centerY,
      );
      expect(centerColor.toValue(), Colors.black.toValue());

      var topLeftColor = await UIInteraction.getPixelColor(
        CanvasPosition.left,
        CanvasPosition.top,
      );
      expect(topLeftColor.toValue(), Colors.black.toValue());

      var bottomRightColor = await UIInteraction.getPixelColor(
        CanvasPosition.right,
        CanvasPosition.bottom,
      );
      expect(bottomRightColor.toValue(), Colors.black.toValue());
    });
  }
}
