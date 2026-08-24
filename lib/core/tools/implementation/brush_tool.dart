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
  static const double _smoothingTensionDivider = 7;

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
    if (_isWithinDistanceFilter(point)) {
      if (isCursor) {
        pathToDraw.lineTo(point.dx, point.dy);
      }
      return;
    }

    final double velocity = _recordPointAndMeasureVelocity(point);

    if (!isSmoothingEnabled()) {
      pathToDraw.lineTo(point.dx, point.dy);
      return;
    }

    if (_canSmoothWithCurrentWindow(velocity)) {
      _appendSmoothedSegment();
    } else {
      _drawDelayedLineSegment();
    }
  }

  bool _isWithinDistanceFilter(Offset point) {
    if (_pointArray.isEmpty) return false;
    return (point - _pointArray.last).distance < _smoothingDistanceFilter;
  }

  double _recordPointAndMeasureVelocity(Offset point) {
    _pointArray.add(point);

    final int currentTime = _now();
    final double distance =
        (point - _pointArray[_pointArray.length - 2]).distance;
    double timeDiff = (currentTime - _lastEventTimestamp).toDouble();
    if (timeDiff == 0) timeDiff = 1.0;

    _lastEventTimestamp = currentTime;
    return distance / timeDiff;
  }

  bool _canSmoothWithCurrentWindow(double velocity) {
    return velocity >= _smoothingSpeedThreshold && _pointArray.length >= 4;
  }

  void _drawDelayedLineSegment() {
    final Offset target = _pointArray[_pointArray.length - 2];
    pathToDraw.lineTo(target.dx, target.dy);
  }

  @override
  void onUp(Offset point, Paint paint) {
    isDrawing = false;

    if (_isDegenerateStroke()) {
      pathToDraw.lineTo(point.dx, point.dy);
      pathToDraw.close();
    } else {
      _flushPendingSmoothedPoint();
      _drawFinalLiftOffPoint(point);
    }

    _pointArray.clear();
  }

  bool _isDegenerateStroke() {
    return _pointArray.length < 2 ||
        pathToDraw.path.getBounds().size == Size.zero;
  }

  void _flushPendingSmoothedPoint() {
    if (!isSmoothingEnabled()) return;
    final Offset pending = _pointArray.last;
    pathToDraw.lineTo(pending.dx, pending.dy);
  }

  void _drawFinalLiftOffPoint(Offset point) {
    if (point == _pointArray.last) return;
    pathToDraw.lineTo(point.dx, point.dy);
  }

  void _appendSmoothedSegment() {
    final int n = _pointArray.length;
    final Offset p0 = _pointArray[n - 4];
    final Offset p1 = _pointArray[n - 3];
    final Offset p2 = _pointArray[n - 2];
    final Offset p3 = _pointArray[n - 1];

    final Offset tangentAtP1 = _estimateTangent(p0, p2);
    final Offset tangentAtP2 = _estimateTangent(p1, p3);

    final Offset control1 = p1 + tangentAtP1;
    final Offset control2 = p2 - tangentAtP2;

    pathToDraw.cubicTo(
      control1.dx,
      control1.dy,
      control2.dx,
      control2.dy,
      p2.dx,
      p2.dy,
    );
  }

  Offset _estimateTangent(Offset before, Offset after) {
    return Offset(
      (after.dx - before.dx) / _smoothingTensionDivider,
      (after.dy - before.dy) / _smoothingTensionDivider,
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