import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:paintroid/workspace/workspace.dart';

class CanvasInteractions {
  final WidgetTester _tester;

  CanvasInteractions(this._tester);

  double stepDegree = 10.0;

  List<Offset> lastOffsets = [];

  Future<CanvasInteractions> drawLineFromCenter(Offset offset) async {
    final drawingCanvasFinder = find.byType(CanvasPainter);
    expect(drawingCanvasFinder, findsOneWidget);
    await _tester.drag(drawingCanvasFinder, offset);
    await _tester.pumpAndSettle();
    return this;
  }

  Future<CanvasInteractions> drawCircle(Offset center, double radius) async {
    for (double theta = 0; theta < 360; theta += stepDegree) {
      final double radians = theta * (math.pi / 180);
      final double x = center.dx + radius * math.cos(radians);
      final double y = center.dy + radius * math.sin(radians);
      lastOffsets.add(Offset(x, y));
    }

    final TestGesture gesture = await _tester.startGesture(lastOffsets.first);

    for (final offset in lastOffsets.skip(1)) {
      await gesture.moveTo(offset);
      await _tester.pump();
    }

    await gesture.up();
    return this;
  }

  Future<int> getPixelColor(int x, int y) async {
    final paintingLayerFinder = find.byType(PaintingLayer);
    expect(paintingLayerFinder, findsOneWidget);
    final RenderRepaintBoundary boundary =
        _tester.renderObject(paintingLayerFinder);
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return img.decodeImage(byteData!.buffer.asUint8List())!.getPixel(x, y);
  }
}
