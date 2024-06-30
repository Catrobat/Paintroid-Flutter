import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:paintroid/app.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';

import 'canvas_positions.dart';
import 'widget_finder.dart';

class UIInteraction {
  static late WidgetTester tester;

  static void initialize(WidgetTester widgetTester) {
    tester = widgetTester;
  }

  static Future<Color> getPixelColor(int x, int y) async {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final canvasStateNotifier = container.read(canvasStateProvider.notifier);
    await canvasStateNotifier.updateCachedImage();
    final cachedImage = container.read(canvasStateProvider).cachedImage;

    if (cachedImage == null) return Colors.transparent;

    final byteData = await cachedImage.toByteData();
    if (byteData == null) return Colors.transparent;
    final rawBytes = byteData.buffer.asUint8List();
    final image =
        img.Image.fromBytes(cachedImage.width, cachedImage.height, rawBytes);
    var pixel = image.getPixel(x, y);

    final a = img.getAlpha(pixel);
    final r = img.getRed(pixel);
    final g = img.getGreen(pixel);
    final b = img.getBlue(pixel);

    final argbColor = (a << 24) | (r << 16) | (g << 8) | b;
    return Color(argbColor);
  }

  static Future<void> createNewImage() async {
    expect(WidgetFinder.newImageButton, findsOneWidget);
    await tester.tap(WidgetFinder.newImageButton);
    await tester.pumpAndSettle();
    await _initializeCanvasDimensions();
  }

  static Future<void> selectTool(String toolName) async {
    expect(WidgetFinder.toolsTab, findsOneWidget);
    await tester.tap(WidgetFinder.toolsTab);
    await tester.pumpAndSettle();

    final Finder tool = find.byKey(ValueKey(toolName));

    expect(tool, findsOneWidget);
    await tester.tap(tool);
    await tester.pumpAndSettle();
  }

  static Tool getCurrentTool() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final toolBoxProvider = container.read(toolBoxStateProvider);
    return toolBoxProvider.currentTool;
  }

  static Future<void> _initializeCanvasDimensions() async {
    final RenderBox canvasBox = tester.renderObject(WidgetFinder.canvas);
    await tester.pumpAndSettle();
    CanvasPosition.initializeCanvasDimensions(canvasBox);
  }

  static Color getCurrentColor() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    return container.read(paintProvider).color;
  }

  static void setColor(Color color) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    container.read(paintProvider.notifier).updateColor(color);
  }

  static Future<void> clickCheckmark() async {
    expect(WidgetFinder.checkMark, findsOneWidget);
    await tester.tap(WidgetFinder.checkMark);
    await tester.pumpAndSettle();
  }

  static Future<void> clickPlus() async {
    expect(WidgetFinder.plusButton, findsOneWidget);
    await tester.tap(WidgetFinder.plusButton);
    await tester.pumpAndSettle();
  }

  static Future<void> clickUndo({int times = 0}) async {
    for (var i = 0; i <= times; i++) {
      expect(WidgetFinder.undoButton, findsOneWidget);
      await tester.tap(WidgetFinder.undoButton);
      await tester.pumpAndSettle();
    }
  }

  static Future<void> clickRedo({int times = 0}) async {
    for (var i = 0; i <= times; i++) {
      expect(WidgetFinder.redoButton, findsOneWidget);
      await tester.tap(WidgetFinder.redoButton);
      await tester.pumpAndSettle();
    }
  }

  static Future<void> dragFromTo(Offset from, Offset to) async {
    final TestGesture gesture = await tester.startGesture(from);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await gesture.moveTo(to);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await gesture.up();
    await tester.pumpAndSettle();
  }

  static Future<void> tapAt(Offset position) async {
    await tester.tapAt(position);
    await tester.pumpAndSettle();
  }

  static void expectVertexStackLength(int length) {
    final tool = getCurrentTool();
    expect((tool as LineTool).vertexStack.length, length);
  }
}
