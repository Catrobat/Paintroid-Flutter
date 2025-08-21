import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:paintroid/app.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/providers/object/tools/shapes_tool_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool.dart';
import 'package:paintroid/core/tools/line_tool/line_tool.dart';
import 'package:paintroid/core/tools/tool.dart';

import 'canvas_positions.dart';
import 'widget_finder.dart';

class UIInteraction {
  static late WidgetTester tester;

  static void initialize(WidgetTester widgetTester) {
    tester = widgetTester;
  }

  static Offset _localToGlobal(Offset localPoint, Offset center, double angle) {
    final double cosA = math.cos(angle);
    final double sinA = math.sin(angle);
    final double rotatedX = localPoint.dx * cosA - localPoint.dy * sinA;
    final double rotatedY = localPoint.dx * sinA + localPoint.dy * cosA;
    return Offset(rotatedX + center.dx, rotatedY + center.dy);
  }

  static Future<
      (
        Color topLeft,
        Color topRight,
        Color bottomLeft,
        Color bottomRight,
      )> getSquareShapeColors() async {
    final shapesTool = getShapesTool();
    final boundingBox = shapesTool.boundingBox;
    final paint = getCurrentPaint();
    final padding = (paint.strokeWidth / 2) + 15.0;

    final center = boundingBox.center;
    final halfWidth = boundingBox.width / 2;
    final halfHeight = boundingBox.height / 2;
    final angle = boundingBox.angle;

    final localTopLeftPadded =
        Offset(-halfWidth + padding, -halfHeight + padding);
    final localTopRightPadded =
        Offset(halfWidth - padding, -halfHeight + padding);
    final localBottomLeftPadded =
        Offset(-halfWidth + padding, halfHeight - padding);
    final localBottomRightPadded =
        Offset(halfWidth - padding, halfHeight - padding);

    final topLeft = _localToGlobal(localTopLeftPadded, center, angle);
    final topRight = _localToGlobal(localTopRightPadded, center, angle);
    final bottomLeft = _localToGlobal(localBottomLeftPadded, center, angle);
    final bottomRight = _localToGlobal(localBottomRightPadded, center, angle);

    final topLeftPixel =
        await getPixelColor(topLeft.dx.toInt(), topLeft.dy.toInt());
    final topRightPixel =
        await getPixelColor(topRight.dx.toInt(), topRight.dy.toInt());
    final bottomLeftPixel =
        await getPixelColor(bottomLeft.dx.toInt(), bottomLeft.dy.toInt());
    final bottomRightPixel =
        await getPixelColor(bottomRight.dx.toInt(), bottomRight.dy.toInt());

    return (topLeftPixel, topRightPixel, bottomLeftPixel, bottomRightPixel);
  }

  static Future<
      (
        Color left,
        Color right,
        Color top,
        Color bottom,
      )> getEllipseShapeColors() async {
    final shapesTool = getShapesTool();
    final boundingBox = shapesTool.boundingBox;
    final paint = getCurrentPaint();
    final strokePadding = (paint.strokeWidth / 2) + 15.0;

    final center = boundingBox.center;
    final angle = boundingBox.angle;

    final double radiusXPadded =
        math.max(0.0, boundingBox.width / 2 - strokePadding);
    final double radiusYPadded =
        math.max(0.0, boundingBox.height / 2 - strokePadding);

    final localLeft = Offset(-radiusXPadded, 0);
    final localRight = Offset(radiusXPadded, 0);
    final localTop = Offset(0, -radiusYPadded);
    final localBottom = Offset(0, radiusYPadded);

    final left = _localToGlobal(localLeft, center, angle);
    final right = _localToGlobal(localRight, center, angle);
    final top = _localToGlobal(localTop, center, angle);
    final bottom = _localToGlobal(localBottom, center, angle);

    final leftPixel = await getPixelColor(left.dx.toInt(), left.dy.toInt());
    final rightPixel = await getPixelColor(right.dx.toInt(), right.dy.toInt());
    final topPixel = await getPixelColor(top.dx.toInt(), top.dy.toInt());
    final bottomPixel =
        await getPixelColor(bottom.dx.toInt(), bottom.dy.toInt());

    return (leftPixel, rightPixel, topPixel, bottomPixel);
  }

  static Future<Color> getPixelColor(int x, int y, {int radius = 0}) async {
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

    if (radius != 0) {
      for (int i = x - radius; i <= x + radius; i++) {
        for (int j = y - radius; j <= y + radius; j++) {
          if (i < 0 || i >= image.width || j < 0 || j >= image.height) {
            continue;
          }
          final argbColor = getColorAtPixel(image, i, j);
          if (argbColor != 0 && Color(argbColor).a != 0) {
            return Color(argbColor);
          }
        }
      }
      return Colors.transparent;
    }

    if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
      return Colors.transparent;
    }
    final argbColor = getColorAtPixel(image, x, y);
    return Color(argbColor);
  }

  static int getColorAtPixel(img.Image image, int x, int y) {
    var pixel = image.getPixel(x, y);
    final a = img.getAlpha(pixel);
    final r = img.getRed(pixel);
    final g = img.getGreen(pixel);
    final b = img.getBlue(pixel);

    final argbColor = (a << 24) | (r << 16) | (g << 8) | b;
    return argbColor;
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

  static ShapesTool getShapesTool() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    return container.read(shapesToolProvider);
  }

  static Future<void> _initializeCanvasDimensions() async {
    final RenderBox canvasBox = tester.renderObject(WidgetFinder.canvas);
    await tester.pumpAndSettle();
    CanvasPosition.initializeCanvasDimensions(canvasBox);
  }

  static double get boundingBoxPadding =>
      getCurrentPaint().strokeWidth + GraphicFactory.guidePaint.strokeWidth;

  static Color getCurrentColor() => getCurrentPaint().color;

  static Paint getCurrentPaint() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    return container.read(paintProvider);
  }

  static void setColor(Color color) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    container.read(paintProvider.notifier).updateColor(color);
  }

  static Future<void> clickBackButton() async {
    await tester.pageBack();
    await tester.pumpAndSettle();
  }

  static Future<void> clickDiscard() async {
    expect(WidgetFinder.genericDialogActionDiscard, findsOneWidget);
    await tester.tap(WidgetFinder.genericDialogActionDiscard);
    await tester.pumpAndSettle();
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

  static Future<void> selectEllipseShapeTypeChip() async {
    expect(WidgetFinder.ellipseShapeTypeChip, findsOneWidget);
    await tester.tap(WidgetFinder.ellipseShapeTypeChip);
    await tester.pumpAndSettle();
  }

  static Future<void> clickRedo({int times = 0}) async {
    for (var i = 0; i <= times; i++) {
      expect(WidgetFinder.redoButton, findsOneWidget);
      await tester.tap(WidgetFinder.redoButton);
      await tester.pumpAndSettle();
    }
  }

  static Future<void> dragFromTo(
    Offset from,
    Offset to, {
    int steps = 1,
  }) async {
    final TestGesture gesture = await tester.startGesture(from);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    final dx = (to.dx - from.dx) / steps;
    final dy = (to.dy - from.dy) / steps;

    for (int i = 1; i <= steps; i++) {
      final Offset nextPoint = Offset(from.dx + dx * i, from.dy + dy * i);
      await gesture.moveTo(nextPoint);
      await tester.pumpAndSettle(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();
  }

  static Future<void> tapAt(Offset position, {int times = 0}) async {
    for (var i = 0; i <= times; i++) {
      await tester.tapAt(position);
    }
    await tester.pumpAndSettle();
  }

  static void expectVertexStackLength(int length) {
    final tool = getCurrentTool();
    expect((tool as LineTool).vertexStack.length, length);
  }

  static int getUndoStackLength() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final commandManager = container.read(commandManagerProvider);
    return commandManager.undoStack.length;
  }

  static int getRedoStackLength() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final commandManager = container.read(commandManagerProvider);
    return commandManager.redoStack.length;
  }
}
