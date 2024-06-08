// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/utils/distance_calculator.dart';

class Vertex {
  Vertex(
      {required this.vertexCenter,
      required this.outgoingPathCommand,
      required this.ingoingPathCommand});

  Offset vertexCenter;
  LineCommand? ingoingPathCommand;
  LineCommand? outgoingPathCommand;

  static const int PAINT_ALPHA = 128;
  static const double VERTEX_PAINT_STROKE_WIDTH = 2.0;
  static const double VERTEX_RADIUS = 30.0;

  void setOutgoingPath(LineCommand updatedOutgoingPath) {
    outgoingPathCommand = updatedOutgoingPath;
  }

  void updateVertexCenter(Offset updatedVertexCenter) {
    vertexCenter = updatedVertexCenter;
  }

  bool wasClicked(Offset clickedCoordinate) {
    double distanceFromCenter =
        DistanceCalculator.calculateDistanceBetweenTwoPoints(vertexCenter.dx,
            vertexCenter.dy, clickedCoordinate.dx, clickedCoordinate.dy);
    if (distanceFromCenter <= VERTEX_RADIUS) return true;
    return false;
  }

  static Paint getVertexPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade600.withAlpha(PAINT_ALPHA)
      ..strokeWidth = VERTEX_PAINT_STROKE_WIDTH;
  }
}
