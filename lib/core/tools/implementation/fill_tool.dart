import 'dart:ui';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/fill_command.dart';

class FillTool extends Tool {
  final GraphicFactory graphicFactory;
  final CanvasPainterProvider canvasPainterProvider;
  final CanvasStateProvider canvasStateProvider;
  final maxAbsoluteTolerance = 2.0;
  double tolerancePercent = 12;
 
  @visibleForTesting
  late FillCommand fillCommand;
  late Paint fillPaint;
  late Uint8List pixels;
  late double prevStrokeSize;
  late Uint8List visited;
  late Color clickedColor;
  late int height;
  late int width;
  final queue = Queue<Range>();

  FillTool({
    required super.type,
    required super.commandManager,
    required super.commandFactory,
    required this.graphicFactory,
    required this.canvasStateProvider,
    required this.canvasPainterProvider,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {}

  @override
  void onDrag(Offset point, Paint paint) {}

  @override
  Future<void> onUp(Offset point, Paint paint) async{
    fillPaint = graphicFactory.copyPaint(paint);
    final fillPoints = await _initFillAlgorithm(point);
    fillCommand = commandFactory.createFillCommand(fillPoints, fillPaint);
    commandManager.addGraphicCommand(fillCommand);
    canvasPainterProvider.repaint();
    canvasStateProvider.updateCachedImage();
  }

  @override
  void onCancel() {
    commandManager.discardLastCommand();
  }

  @override
  void onCheckmark(Paint paint) {}

  @override
  void onPlus() {}

  @override
  void onRedo() {
    commandManager.redo();
  }

  @override
  void onUndo() {
    commandManager.undo();
  }

  void updateTolerance(double newTolerance) {
    tolerancePercent = newTolerance;
  }

  void savePrevStrokeSize(double prevStrokeSize) {
    this.prevStrokeSize = prevStrokeSize;
  }

  Color _getPixelColor(int width, int x, int y) {
    final index = (y * width + x) * 4;

    return Color.fromARGB(
      pixels[index + 3],
      pixels[index],
      pixels[index + 1],
      pixels[index + 2],
    );
  }

  bool _isPixelWithinColorTolerance(Color pixelColor, Color clickedColor) {
    if (pixelColor == clickedColor) return true;
    double absoluteTolerance = maxAbsoluteTolerance * tolerancePercent / 100.0;
    double redDiff = pixelColor.r - clickedColor.r;
    double greenDiff = pixelColor.g - clickedColor.g;
    double blueDiff = pixelColor.b - clickedColor.b;
    double alphaDiff = pixelColor.a - clickedColor.a;
    return ((redDiff * redDiff) + (greenDiff * greenDiff) + (blueDiff * blueDiff) + (alphaDiff * alphaDiff)) <= (absoluteTolerance * alphaDiff);
  }

  Future<List<Offset>> _initFillAlgorithm(Offset center) async {
    List<Offset> points = [];

    Image? canvasImage = canvasStateProvider.currentState.cachedImage;
    if (canvasImage == null) return points;

    ByteData? byteData = await canvasImage.toByteData();
    if (byteData == null) return points;

    pixels = byteData.buffer.asUint8List();
    height = canvasImage.height;
    width = canvasImage.width;

    return _scanlineFloodFill(center);
  }

  Future<List<Offset>> _scanlineFloodFill(Offset center) async{
    final List<Offset> points = <Offset>[];
    visited = Uint8List(width * height);
    int startX = center.dx.toInt();
    int startY = center.dy.toInt();
    
    queue.add(Range(startY, startX, startX, false));
    clickedColor = _getPixelColor(width, startX, startY);

    while (queue.isNotEmpty) {
      final range = queue.removeFirst();
      
      int y = range.line;
      int left = range.start;
      int right = range.end;
      
      if (y < 0 || y >= height) continue;
      if (left < 0 || left >= width) continue;
      if (right < 0 || right >= width) continue;

      final indexLeft = y * width + left;
      final indexRight = y * width + right;
      if (visited[indexLeft] == 1 && visited[indexRight] == 1) continue;

      if (!range.completed) {
        while (left > 0 &&
            visited[y * width + left - 1] == 0 &&
            _isPixelWithinColorTolerance(_getPixelColor(width, left - 1, y), clickedColor)) {
          left--;
        }

        while (right < width - 1 &&
            visited[y * width + right + 1] == 0 &&
            _isPixelWithinColorTolerance(_getPixelColor(width, right + 1, y), clickedColor)) {
          right++;
        }
      }

      for (int i = left; i <= right; i++) {
        visited[y * width + i] = 1;
      }

      points.add(Offset(left.toDouble(), y.toDouble()));
      points.add(Offset(right.toDouble(), y.toDouble()));

      _findNewRanges(y, left, right, false); //UP
      _findNewRanges(y, left, right, true);  //DOWN
    }
    
    return points;
  }

  void _findNewRanges(int y, int left, int right, bool direction) {
    bool pixelChanged = false;
    int newRangeLeft = left;
    int delta = direction ? 1 : -1;
    for (int i = left; i <= right; i++) {
      if (y > 0 && y < height - 1) {
        final index = (y + delta) * width + i;
        if (visited[index] == 0) {
          if (_isPixelWithinColorTolerance(_getPixelColor(width, i, y + delta), clickedColor)) {
            if (!pixelChanged){
              newRangeLeft = i;
              pixelChanged = true;
            } else {
              if (i == right) queue.add(Range(y + delta, newRangeLeft, right, false));
            }
          } else {
            if (pixelChanged){
              if (newRangeLeft == left){
                queue.add(Range(y + delta, newRangeLeft, i - 1, false));
              } else {
                queue.add(Range(y + delta, newRangeLeft, i - 1, true));
              }
              pixelChanged = false;
            }
          }
        }
      }
    }
  }
}

class Range {
  int line = 0;
  int start = 0;
  int end = 0;
  bool completed = false;

  Range(this.line, this.start, this.end, this.completed);
}