import 'package:flutter/material.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

class CursorTool extends BrushTool {
  static const double _tapTolerance = 10.0;
  static const double _circleRadius = 40.0;
  static const double _crossLength = 90.0;
  static const double _crossThickness = 10.0;
  static const double _strokeWidth = 10.0;

  final Offset canvasCenter;
  Offset lastPoint = Offset.zero;
  bool isActive = false;

  bool _isCurrentlyDrawing = false;
  Offset? _initialTouchPoint;
  Offset? _initialCursorPosition;
  bool _hasDragged = false;

  CursorTool({
    required super.commandFactory,
    required super.commandManager,
    required super.graphicFactory,
    required this.canvasCenter,
    required super.isSmoothingEnabled,
    required super.type,
    super.isCursor = true,
  }) {
    lastPoint = canvasCenter;
  }

  void toggleActive() => isActive = !isActive;

  void setCursorPosition(Offset position) => lastPoint = position;

  @override
  void onDown(Offset point, Paint paint) {
    _initializeTouch(point);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    _updateDragState(point);
    _updateCursorPosition(point);

    if (isActive && !_isCurrentlyDrawing) {
      super.onDown(lastPoint, paint);
      _isCurrentlyDrawing = true;
    }

    if (isActive && _isCurrentlyDrawing) {
      super.onDrag(lastPoint, paint);
    }
  }

  @override
  void onUp(Offset point, Paint paint) {
    _updateCursorPosition(point);

    if (_isTap()) {
      _handleTap();
      return;
    }

    if (isActive && _isCurrentlyDrawing) {
      super.onUp(lastPoint, paint);
    }

    _finalizeDraw();
  }

  void drawCursorIcon(Canvas canvas, Paint paint) {
    final cursorColor = isActive ? Colors.red : Colors.black;
    final circlePaint = _createCirclePaint(cursorColor);
    final crossPaint = _createCrossPaint(cursorColor);

    canvas.drawCircle(lastPoint, _circleRadius, circlePaint);
    _drawCrossLines(canvas, crossPaint);
  }

  void _initializeTouch(Offset point) {
    _initialTouchPoint = point;
    _initialCursorPosition = lastPoint;
    _hasDragged = false;
    _isCurrentlyDrawing = false;
  }

  void _updateDragState(Offset point) {
    if (_initialTouchPoint != null) {
      final distance = (point - _initialTouchPoint!).distance;
      if (distance > _tapTolerance) _hasDragged = true;
    }
  }

  void _updateCursorPosition(Offset point) {
    if (_initialTouchPoint != null && _initialCursorPosition != null) {
      final delta = point - _initialTouchPoint!;
      lastPoint = _initialCursorPosition! + delta;
    }
  }

  bool _isTap() => !_hasDragged;

  void _handleTap() {
    toggleActive();
    if (!isActive && _isCurrentlyDrawing) {
      _isCurrentlyDrawing = false;
      _resetTracking();
    }
  }

  void _finalizeDraw() {
    _isCurrentlyDrawing = false;
    _resetTracking();
  }

  void _resetTracking() {
    _initialTouchPoint = null;
    _initialCursorPosition = null;
    _hasDragged = false;
  }

  Paint _createCirclePaint(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = _strokeWidth
    ..isAntiAlias = true;

  Paint _createCrossPaint(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = _crossThickness
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  @override
  void onCancel() {
    if (_isCurrentlyDrawing) {
      super.onUp(lastPoint, Paint());
    }
    _isCurrentlyDrawing = false;
    _resetTracking();
  }

  void _drawCrossLines(Canvas canvas, Paint paint) {
    final crossStart = _circleRadius;
    final crossEnd = crossStart + _crossLength;

    final lines = [
      (
        Offset(lastPoint.dx, lastPoint.dy - crossEnd),
        Offset(lastPoint.dx, lastPoint.dy - crossStart)
      ),
      (
        Offset(lastPoint.dx, lastPoint.dy + crossStart),
        Offset(lastPoint.dx, lastPoint.dy + crossEnd)
      ),
      (
        Offset(lastPoint.dx - crossEnd, lastPoint.dy),
        Offset(lastPoint.dx - crossStart, lastPoint.dy)
      ),
      (
        Offset(lastPoint.dx + crossStart, lastPoint.dy),
        Offset(lastPoint.dx + crossEnd, lastPoint.dy)
      ),
    ];

    for (final (start, end) in lines) {
      canvas.drawLine(start, end, paint);
    }
  }
}
