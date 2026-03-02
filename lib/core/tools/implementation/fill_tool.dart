import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/tool.dart';

class FillTool extends Tool {
  final GraphicFactory graphicFactory;
  final Future<ui.Image?> Function() getSourceImage;
  final Future<void> Function() onFillApplied;
  bool _isFilling = false;

  FillTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.graphicFactory,
    required this.getSourceImage,
    required this.onFillApplied,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(ui.Offset point, ui.Paint paint) {
    if (_isFilling) {
      return;
    }
    _isFilling = true;
    unawaited(_fill(point, paint));
  }

  Future<void> _fill(ui.Offset point, ui.Paint paint) async {
    try {
      final sourceImage = await getSourceImage();
      if (sourceImage == null) {
        return;
      }

      final width = sourceImage.width;
      final height = sourceImage.height;
      if (width <= 0 || height <= 0) {
        return;
      }

      final startX = point.dx.floor();
      final startY = point.dy.floor();
      if (startX < 0 || startX >= width || startY < 0 || startY >= height) {
        return;
      }

      final sourceData =
          await sourceImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (sourceData == null) {
        return;
      }
      final pixels = sourceData.buffer.asUint8List();

      final startIndex = (startY * width + startX) * 4;
      final sourceR = pixels[startIndex];
      final sourceG = pixels[startIndex + 1];
      final sourceB = pixels[startIndex + 2];
      final sourceA = pixels[startIndex + 3];

      final targetColor = paint.color;
      final targetR = (targetColor.r * 255).round();
      final targetG = (targetColor.g * 255).round();
      final targetB = (targetColor.b * 255).round();
      final targetA = (targetColor.a * 255).round();

      if (sourceR == targetR &&
          sourceG == targetG &&
          sourceB == targetB &&
          sourceA == targetA) {
        return;
      }

      final queue = Queue<int>()..add(startY * width + startX);
      while (queue.isNotEmpty) {
        final pixelPos = queue.removeFirst();
        final x = pixelPos % width;
        final y = pixelPos ~/ width;
        final index = pixelPos * 4;

        if (pixels[index] != sourceR ||
            pixels[index + 1] != sourceG ||
            pixels[index + 2] != sourceB ||
            pixels[index + 3] != sourceA) {
          continue;
        }

        pixels[index] = targetR;
        pixels[index + 1] = targetG;
        pixels[index + 2] = targetB;
        pixels[index + 3] = targetA;

        if (x > 0) queue.add(pixelPos - 1);
        if (x < width - 1) queue.add(pixelPos + 1);
        if (y > 0) queue.add(pixelPos - width);
        if (y < height - 1) queue.add(pixelPos + width);
      }

      final filledImage = await _decodeFromRgba(
        Uint8List.fromList(pixels),
        width,
        height,
      );
      final pngData =
          await filledImage.toByteData(format: ui.ImageByteFormat.png);
      if (pngData == null) {
        return;
      }

      final savedPaint = graphicFactory.copyPaint(paint);
      final command = commandFactory.createFillCommand(
        savedPaint,
        pngData.buffer.asUint8List(),
      );
      await command.prepareForRuntime();
      commandManager.addGraphicCommand(command);
      await onFillApplied();
    } finally {
      _isFilling = false;
    }
  }

  Future<ui.Image> _decodeFromRgba(Uint8List rgba, int width, int height) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgba,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    return completer.future;
  }

  @override
  void onDrag(ui.Offset point, ui.Paint paint) {}

  @override
  void onUp(ui.Offset point, ui.Paint paint) {}

  @override
  void onCancel() {
    _isFilling = false;
  }

  @override
  void onCheckmark(ui.Paint paint) {}

  @override
  void onPlus() {}

  @override
  void onUndo() {
    commandManager.undo();
  }

  @override
  void onRedo() {
    commandManager.redo();
  }
}
