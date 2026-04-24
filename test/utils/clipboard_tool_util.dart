import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/object/clipboard_tool_options_state_provider.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'test_utils.dart';

class ClipboardIntegrationTestUtils {
  static Future<void> launchAppAndInit(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          IDeviceService.sizeProvider
              .overrideWithValue(TestConstants.standardDeviceSize),
        ],
        child: App(showOnboardingPage: false),
      ),
    );
    UIInteraction.initialize(tester);
    await UIInteraction.createNewImage();
    await tester.pumpAndSettle();
  }

  static Future<void> selectTool(WidgetTester tester, String toolName) async {
    await UIInteraction.selectTool(toolName);
    await tester.pumpAndSettle();
  }

  static Future<ui.Image> createTestImage(int w, int h) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..color = const ui.Color(0xFF00FF00);
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), paint);
    final picture = recorder.endRecording();
    return picture.toImage(w, h);
  }

  static Future<void> drawSomethingOnCanvas(WidgetTester tester) async {
    await selectTool(tester, ToolData.SHAPES.name);
    await UIInteraction.tapAt(CanvasPosition.center);
    await tester.pumpAndSettle();
    await UIInteraction.clickCheckmark();
    await tester.pumpAndSettle();
  }

  static Future<void> drawSomethingElseOnCanvas(WidgetTester tester) async {
    await selectTool(tester, ToolData.SHAPES.name);
    await UIInteraction.tapAt(CanvasPosition.topLeft);
    await tester.pumpAndSettle();
    await UIInteraction.clickCheckmark();
    await tester.pumpAndSettle();
  }

  static Future<ui.Image?> getCanvasImage(WidgetTester tester,
      {bool forceUpdate = true}) async {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    if (forceUpdate) {
      await container.read(canvasStateProvider.notifier).updateCachedImage();
    }
    return container.read(canvasStateProvider).cachedImage;
  }

  static bool getHasCopiedContent(WidgetTester tester) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    return container.read(clipboardToolOptionsStateProvider).hasCopiedContent;
  }
}
