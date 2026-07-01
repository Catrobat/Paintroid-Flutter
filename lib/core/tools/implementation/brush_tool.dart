import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/tool.dart';

class BrushTool extends Tool {
  final GraphicFactory graphicFactory;
  final bool isCursor;
  final List<Offset> _pointArray = [];
  int _lastEventTimestamp = 0;
  static const double _speedThreshold = 0.02;
  bool isDrawing = false;
  final bool Function() isSmoothingEnabled;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;

  BrushTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required this.isSmoothingEnabled,
    required super.type,
    this.isCursor = false,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    isDrawing = true;
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);
    _pointArray.clear();
    _pointArray.add(point);
    _lastEventTimestamp = DateTime.now().millisecondsSinceEpoch;
    
    Paint savedPaint = graphicFactory.copyPaint(paint);
    final command = commandFactory.createPathCommand(
      pathToDraw,
      savedPaint,
      isCursor: isCursor,
    );
    commandManager.addGraphicCommand(command);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    if (_pointArray.isNotEmpty) {
      double distFromLast = (point - _pointArray.last).distance;
      if (distFromLast < 5.0) return; 
    }

    _pointArray.add(point);

    int currentTime = DateTime.now().millisecondsSinceEpoch;
    double distance = (point - _pointArray[_pointArray.length - 2]).distance;
    double timeDiff = (currentTime - _lastEventTimestamp).toDouble();
    if (timeDiff == 0) timeDiff = 1.0;
    
    double velocity = distance / timeDiff;

    if (!isSmoothingEnabled() || paint.strokeWidth > 1.0 || velocity < _speedThreshold || _pointArray.length < 3) {
      pathToDraw.lineTo(point.dx, point.dy);
      return;
    }

    _applySmoothing();
  }

  @override
  void onUp(Offset point, Paint paint) {
    isDrawing = false;

    if (_pointArray.length < 2 || pathToDraw.path.getBounds().size == Size.zero) {
      pathToDraw.lineTo(point.dx, point.dy);
      pathToDraw.close();
    }
    
    _pointArray.clear(); 
  }

  void _applySmoothing() {
    pathToDraw.reset();
    pathToDraw.moveTo(_pointArray.first.dx, _pointArray.first.dy);

    List<Offset> diffPointArray = List.filled(_pointArray.length, Offset.zero);
    
    for (int i = 1; i < _pointArray.length - 1; i++) {
      diffPointArray[i] = Offset(
        (_pointArray[i + 1].dx - _pointArray[i - 1].dx) / 3.0,
        (_pointArray[i + 1].dy - _pointArray[i - 1].dy) / 3.0,
      );
    }
    
    for (int i = 0; i < _pointArray.length - 1; i++) {
      if (i == 0) {
        pathToDraw.cubicTo(
          _pointArray[i].dx,
          _pointArray[i].dy,
          _pointArray[i + 1].dx - diffPointArray[i + 1].dx,
          _pointArray[i + 1].dy - diffPointArray[i + 1].dy,
          _pointArray[i + 1].dx,
          _pointArray[i + 1].dy,
        );
      } else {
        pathToDraw.cubicTo(
          _pointArray[i].dx + diffPointArray[i].dx,
          _pointArray[i].dy + diffPointArray[i].dy,
          _pointArray[i + 1].dx - diffPointArray[i + 1].dx,
          _pointArray[i + 1].dy - diffPointArray[i + 1].dy,
          _pointArray[i + 1].dx,
          _pointArray[i + 1].dy,
        );
      }
    }
  }

  @override
  void onCancel() {
    isDrawing = false;
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
}