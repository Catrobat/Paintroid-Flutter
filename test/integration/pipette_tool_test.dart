import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/core/utils/color_utils.dart';
import 'package:paintroid/core/providers/object/device_service.dart';

import '../utils/canvas_positions.dart';
import '../utils/ui_interaction.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;
  const Color redColor = Color(0xFFFF0000);
  const Color blackColor = Color(0xFF000000);

  setUp(() async {
    sut = ProviderScope(
      overrides: [
        IDeviceService.sizeProvider
            .overrideWith((ref) => Future.value(const Size(600, 600)))
      ],
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  testWidgets('[PIPETTE_TOOL]: picking a color from canvas',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();

    UIInteraction.setColor(redColor);
    await UIInteraction.selectTool(ToolData.BRUSH.name);
    await UIInteraction.tapAt(CanvasPosition.center);

    var color = await UIInteraction.getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
    );
    expect(color.toValue(), redColor.toValue());

    UIInteraction.setColor(blackColor);
    expect(UIInteraction.getCurrentColor().toValue(), blackColor.toValue());

    await UIInteraction.selectTool(ToolData.PIPETTE.name);
    final gesture = await UIInteraction.tapDownAt(CanvasPosition.center);

    expect(find.byType(RawMagnifier), findsOneWidget);

    await UIInteraction.tapUpAt(gesture);
    await tester.pump(const Duration(milliseconds: 200));

    expect(UIInteraction.getCurrentColor().toValue(), redColor.toValue());

    await UIInteraction.selectTool(ToolData.BRUSH.name);
    await UIInteraction.tapAt(CanvasPosition.topLeft);

    color = await UIInteraction.getPixelColor(
      CanvasPosition.left,
      CanvasPosition.top,
    );
    expect(color.toValue(), redColor.toValue());
  });

  testWidgets('[PIPETTE_TOOL]: undo and redo color picking',
      (WidgetTester tester) async {
    UIInteraction.initialize(tester);
    await tester.pumpWidget(sut);
    await UIInteraction.createNewImage();

    UIInteraction.setColor(redColor);
    await UIInteraction.selectTool(ToolData.BRUSH.name);
    await UIInteraction.tapAt(CanvasPosition.center);

    UIInteraction.setColor(blackColor);

    await UIInteraction.selectTool(ToolData.PIPETTE.name);
    await UIInteraction.tapAt(CanvasPosition.center);
    await tester.pump(const Duration(milliseconds: 200));

    expect(UIInteraction.getCurrentColor().toValue(), redColor.toValue());

    await UIInteraction.clickUndo();
    await tester.pump(const Duration(milliseconds: 200));

    expect(UIInteraction.getCurrentColor().toValue(), blackColor.toValue());

    await UIInteraction.clickRedo();
    await tester.pump(const Duration(milliseconds: 200));

    expect(UIInteraction.getCurrentColor().toValue(), redColor.toValue());
  });
}
