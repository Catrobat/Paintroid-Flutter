import 'dart:ui';
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
import 'package:paintroid/ui/utils/shape_path_generator.dart';
import 'canvas_positions.dart';
import 'widget_finder.dart';

class UIInteraction {
  static late WidgetTester tester;
  static const double _kShapeVisualPadding = 15.0;

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

  static void setStrokeWidth(double newStrokeWidth) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    container.read(paintProvider.notifier).updateStrokeWidth(newStrokeWidth);
  }

  static Color _getColorFromPreparedImage(img.Image image, int x, int y,
      {int radius = 0}) {
    if (radius != 0) {
      for (int i = x - radius; i <= x + radius; i++) {
        for (int j = y - radius; j <= y + radius; j++) {
          if (i < 0 || i >= image.width || j < 0 || j >= image.height) {
            continue;
          }
          final argbColor = getColorAtPixel(image, i, j);
          if ((argbColor & 0xFF000000) != 0) {
            return Color(argbColor);
          }
        }
      }
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        final centerArgbColor = getColorAtPixel(image, x, y);
        return Color(centerArgbColor);
      }
      return Colors.transparent;
    }

    if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
      return Colors.transparent;
    }
    final argbColor = getColorAtPixel(image, x, y);
    return Color(argbColor);
  }

  static Future<
      (
        Color topLeft,
        Color topRight,
        Color bottomLeft,
        Color bottomRight,
      )> getSquareShapeColors() async {
    final shapesTool = getShapesTool();
    final currentPaint = getCurrentPaint();
    final boundingBox = shapesTool.boundingBox;

    final double padding = calculateShapePadding(currentPaint.strokeWidth);

    final double halfWidth = boundingBox.width / 2;
    final double halfHeight = boundingBox.height / 2;
    final double angle = boundingBox.angle;
    final Offset center = boundingBox.center;

    final Offset localTopLeft =
        Offset(-halfWidth + padding, -halfHeight + padding);
    final Offset localTopRight =
        Offset(halfWidth - padding, -halfHeight + padding);
    final Offset localBottomLeft =
        Offset(-halfWidth + padding, halfHeight - padding);
    final Offset localBottomRight =
        Offset(halfWidth - padding, halfHeight - padding);

    Offset toGlobal(Offset localPoint) {
      final double s = math.sin(angle);
      final double c = math.cos(angle);
      final double rotatedX = localPoint.dx * c - localPoint.dy * s;
      final double rotatedY = localPoint.dx * s + localPoint.dy * c;
      return Offset(rotatedX + center.dx, rotatedY + center.dy);
    }

    final Offset globalTopLeft = toGlobal(localTopLeft);
    final Offset globalTopRight = toGlobal(localTopRight);
    final Offset globalBottomLeft = toGlobal(localBottomLeft);
    final Offset globalBottomRight = toGlobal(localBottomRight);

    final path = Path()
      ..moveTo(globalTopLeft.dx, globalTopLeft.dy)
      ..lineTo(globalTopRight.dx, globalTopRight.dy)
      ..lineTo(globalBottomRight.dx, globalBottomRight.dy)
      ..lineTo(globalBottomLeft.dx, globalBottomLeft.dy)
      ..close();

    path.getBounds();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final canvasStateNotifier = container.read(canvasStateProvider.notifier);
    await canvasStateNotifier.updateCachedImage();
    final cachedImage = container.read(canvasStateProvider).cachedImage;

    if (cachedImage == null) {
      return (
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      );
    }
    final byteData = await cachedImage.toByteData();
    if (byteData == null) {
      return (
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      );
    }
    final rawBytes = byteData.buffer.asUint8List();
    final image =
        img.Image.fromBytes(cachedImage.width, cachedImage.height, rawBytes);

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

    final topLeftPixel = _getColorFromPreparedImage(
        image, topLeft.dx.toInt(), topLeft.dy.toInt(),
        radius: 1);
    final topRightPixel = _getColorFromPreparedImage(
        image, topRight.dx.toInt(), topRight.dy.toInt(),
        radius: 1);
    final bottomLeftPixel = _getColorFromPreparedImage(
        image, bottomLeft.dx.toInt(), bottomLeft.dy.toInt(),
        radius: 1);
    final bottomRightPixel = _getColorFromPreparedImage(
        image, bottomRight.dx.toInt(), bottomRight.dy.toInt(),
        radius: 1);

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
    final currentPaint = getCurrentPaint();
    final boundingBox = shapesTool.boundingBox;
    final double drawingPadding = currentPaint.strokeWidth * 2;
    final double effectiveWidth =
        math.max(0.0, boundingBox.width - drawingPadding);
    final double effectiveHeight =
        math.max(0.0, boundingBox.height - drawingPadding);
    final double halfEffectiveWidth = effectiveWidth / 2;
    final double halfEffectiveHeight = effectiveHeight / 2;
    final Offset pLeftLocal = Offset(-halfEffectiveWidth, 0);
    final Offset pRightLocal = Offset(halfEffectiveWidth, 0);
    final Offset pTopLocal = Offset(0, -halfEffectiveHeight);
    final Offset pBottomLocal = Offset(0, halfEffectiveHeight);
    final List<Offset> localPoints = [
      pLeftLocal,
      pRightLocal,
      pTopLocal,
      pBottomLocal
    ];
    final List<Offset> transformedPoints = [];
    final angle = boundingBox.angle;
    final center = boundingBox.center;

    for (final pLocal in localPoints) {
      final double rotatedX =
          pLocal.dx * math.cos(angle) - pLocal.dy * math.sin(angle);
      final double rotatedY =
          pLocal.dx * math.sin(angle) + pLocal.dy * math.cos(angle);
      transformedPoints.add(Offset(rotatedX, rotatedY) + center);
    }

    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final canvasStateNotifier = container.read(canvasStateProvider.notifier);
    await canvasStateNotifier.updateCachedImage();
    final cachedImage = container.read(canvasStateProvider).cachedImage;

    if (cachedImage == null) {
      return (
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      );
    }
    final byteData = await cachedImage.toByteData();
    if (byteData == null) {
      return (
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      );
    }
    final rawBytes = byteData.buffer.asUint8List();
    final image =
        img.Image.fromBytes(cachedImage.width, cachedImage.height, rawBytes);

    final leftPixel = _getColorFromPreparedImage(
        image, transformedPoints[0].dx.toInt(), transformedPoints[0].dy.toInt(),
        radius: 1);
    final rightPixel = _getColorFromPreparedImage(
        image, transformedPoints[1].dx.toInt(), transformedPoints[1].dy.toInt(),
        radius: 1);
    final topPixel = _getColorFromPreparedImage(
        image, transformedPoints[2].dx.toInt(), transformedPoints[2].dy.toInt(),
        radius: 1);
    final bottomPixel = _getColorFromPreparedImage(
        image, transformedPoints[3].dx.toInt(), transformedPoints[3].dy.toInt(),
        radius: 1);

    return (leftPixel, rightPixel, topPixel, bottomPixel);
  }

  static Future<List<Color>> getStarShapeColors() async {
    final shapesTool = getShapesTool();
    final boundingBox = shapesTool.boundingBox;
    final currentPaint = getCurrentPaint();
    final center = boundingBox.center;
    final angle = boundingBox.angle;
    final numberOfPoints = ShapesTool.starShapeNumberOfPoints;
    final double starDrawingPadding = currentPaint.strokeWidth * 2;
    final double radiusX =
        math.max(0.0, (boundingBox.width - starDrawingPadding) / 2);
    final double radiusY =
        math.max(0.0, (boundingBox.height - starDrawingPadding) / 2);
    final double innerRx = radiusX / 2;
    final double innerRy = radiusY / 2;
    final double angleStep = math.pi / numberOfPoints;
    final pointsToSample = <Offset>[];

    for (int i = 0; i < numberOfPoints * 2; i++) {
      final bool isOuter = i % 2 == 0;
      final double currentLocalRx = isOuter ? radiusX : innerRx;
      final double currentLocalRy = isOuter ? radiusY : innerRy;
      final double pointRelativeAngle = i * angleStep - (math.pi / 2);
      double localX = currentLocalRx * math.cos(pointRelativeAngle);
      double localY = currentLocalRy * math.sin(pointRelativeAngle);
      double rotatedX = localX * math.cos(angle) - localY * math.sin(angle);
      double rotatedY = localX * math.sin(angle) + localY * math.cos(angle);
      pointsToSample.add(
          Offset(center.dx + rotatedX, center.dy + (radiusY / 9) + rotatedY));
    }

    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final canvasStateNotifier = container.read(canvasStateProvider.notifier);
    await canvasStateNotifier.updateCachedImage();
    final cachedImage = container.read(canvasStateProvider).cachedImage;

    if (cachedImage == null) {
      return List.filled(pointsToSample.length, Colors.transparent);
    }
    final byteData = await cachedImage.toByteData();
    if (byteData == null) {
      return List.filled(pointsToSample.length, Colors.transparent);
    }
    final rawBytes = byteData.buffer.asUint8List();
    final image =
        img.Image.fromBytes(cachedImage.width, cachedImage.height, rawBytes);

    final colors = <Color>[];
    for (final point in pointsToSample) {
      colors.add(_getColorFromPreparedImage(
          image, point.dx.toInt(), point.dy.toInt(),
          radius: 0));
    }
    return colors;
  }

  static List<Offset> extractPointsFromPath(Path path, {int? numSamples}) {
    final List<Offset> points = [];
    for (PathMetric pathMetric in path.computeMetrics()) {
      if (pathMetric.length == 0) continue;

      double step;
      int count;

      if (numSamples != null && numSamples > 0) {
        count = numSamples;
        step = pathMetric.length / count.toDouble();
        if (step <= 0) step = pathMetric.length;
      } else {
        step = 1.0;
        count = (pathMetric.length / step).ceil();
      }

      for (int i = 0; i < count; i++) {
        final double distance = math.min(i * step, pathMetric.length);
        Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          points.add(tangent.position);
        }
        if (distance >= pathMetric.length) break;
      }
    }
    return points;
  }

  static Future<List<Color>> getHeartShapeColors() async {
    final shapesTool = getShapesTool();
    final boundingBox = shapesTool.boundingBox;
    final currentPaint = getCurrentPaint();

    final double padding = calculateShapePadding(currentPaint.strokeWidth);
    final double paddedWidth = math.max(0, boundingBox.width - 2 * padding);
    final double paddedHeight = math.max(0, boundingBox.height - 2 * padding);

    final path = ShapePathUtils.generateHeartPath(
      width: paddedWidth,
      height: paddedHeight,
      angle: boundingBox.angle,
      center: boundingBox.center,
    );
    final points = extractPointsFromPath(path, numSamples: 8);

    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final canvasStateNotifier = container.read(canvasStateProvider.notifier);
    await canvasStateNotifier.updateCachedImage();
    final cachedImage = container.read(canvasStateProvider).cachedImage;

    if (cachedImage == null) {
      return List.filled(points.length, Colors.transparent);
    }
    final byteData = await cachedImage.toByteData();
    if (byteData == null) return List.filled(points.length, Colors.transparent);
    final rawBytes = byteData.buffer.asUint8List();
    final image =
        img.Image.fromBytes(cachedImage.width, cachedImage.height, rawBytes);

    final colors = <Color>[];
    for (final point in points) {
      colors.add(_getColorFromPreparedImage(
          image, point.dx.toInt(), point.dy.toInt(),
          radius: 0));
    }
    return colors;
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

    return _getColorFromPreparedImage(image, x, y, radius: radius);
  }

  static Future<Color> getCenterPixelColor() async {
    return getPixelColor(
      CanvasPosition.centerX,
      CanvasPosition.centerY,
      radius: 1,
    );
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

  static Future<void> selectShapesToolShapeType(Finder shapeTypeFinder) async {
    expect(shapeTypeFinder, findsOneWidget);
    await tester.tap(shapeTypeFinder);
    await tester.pumpAndSettle();
  }

  static Future<void> selectShapesToolShapeStyle(Finder styleChipFinder) async {
    expect(styleChipFinder, findsOneWidget);
    await tester.tap(styleChipFinder);
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

  static double calculateShapePadding(double strokeWidth) {
    return (strokeWidth / 2) + _kShapeVisualPadding;
  }
}
