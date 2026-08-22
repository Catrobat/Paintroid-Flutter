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
  bool isDrawing = false;
  final bool Function() isSmoothingEnabled;
  final int Function() _now;

  static const double _smoothingSpeedThreshold = 0.02;
  static const double _smoothingDistanceFilter = 5;
  static const double _smoothingTensionDivider = 3;

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
    @visibleForTesting int Function()? now,
  }) : _now = now ?? _systemNow;

  static int _systemNow() => DateTime.now().millisecondsSinceEpoch;

  @override
  void onDown(Offset point, Paint paint) {
    isDrawing = true;
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);
    _pointArray.clear();
    _pointArray.add(point);
    _lastEventTimestamp = _now();

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
      if (distFromLast < _smoothingDistanceFilter) {
        if (isCursor) {
          pathToDraw.lineTo(point.dx, point.dy);
        }
        return; 
      }
    }

    _pointArray.add(point);

    int currentTime = _now();
    double distance = (point - _pointArray[_pointArray.length - 2]).distance;
    double timeDiff = (currentTime - _lastEventTimestamp).toDouble();
    if (timeDiff == 0) timeDiff = 1.0;
    
    double velocity = distance / timeDiff;
    _lastEventTimestamp = currentTime;

    if (!isSmoothingEnabled()) {
      pathToDraw.lineTo(point.dx, point.dy);
      return;
    }

    final int n = _pointArray.length;
    if (velocity >= _smoothingSpeedThreshold && n >= 4) {
      _appendSmoothedSegment();
    } else {
      final Offset target = _pointArray[n - 2];
      pathToDraw.lineTo(target.dx, target.dy);
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    isDrawing = false;

    if (_pointArray.length < 2 || pathToDraw.path.getBounds().size == Size.zero) {
      pathToDraw.lineTo(point.dx, point.dy);
      pathToDraw.close();
    } else {
      if (isSmoothingEnabled()) {
        final Offset pending = _pointArray.last;
        pathToDraw.lineTo(pending.dx, pending.dy);
      }
      if (point != _pointArray.last) {
        pathToDraw.lineTo(point.dx, point.dy);
      }
    }

    _pointArray.clear();
  }

  void _appendSmoothedSegment() {
    final int n = _pointArray.length;
    final Offset p0 = _pointArray[n - 4];
    final Offset p1 = _pointArray[n - 3];
    final Offset p2 = _pointArray[n - 2];
    final Offset p3 = _pointArray[n - 1];

    final Offset tangent1 = Offset(
      (p2.dx - p0.dx) / _smoothingTensionDivider,
      (p2.dy - p0.dy) / _smoothingTensionDivider,
    );
    final Offset tangent2 = Offset(
      (p3.dx - p1.dx) / _smoothingTensionDivider,
      (p3.dy - p1.dy) / _smoothingTensionDivider,
    );

    final Offset control1 = p1 + tangent1;
    final Offset control2 = p2 - tangent2;

    pathToDraw.cubicTo(
      control1.dx,
      control1.dy,
      control2.dx,
      control2.dy,
      p2.dx,
      p2.dy,
    );
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