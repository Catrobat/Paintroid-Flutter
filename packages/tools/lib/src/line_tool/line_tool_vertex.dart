import 'dart:math';

import 'package:command/command.dart';
import 'package:flutter/material.dart';

class Vertex {
  Vertex(
      {required this.vertexCenter,
      required this.outgoingPathCommand,
      required this.ingoingPathCommand});

  Offset vertexCenter;
  LinePathCommand? ingoingPathCommand;
  LinePathCommand? outgoingPathCommand;

  static const int PAINT_ALPHA = 128;
  static const double VERTEX_PAINT_STROKE_WIDTH = 2.0;
  static const double VERTEX_RADIUS = 30.0;

  void setOutgoingPath(LinePathCommand updatedOutgoingPath) {
    outgoingPathCommand = updatedOutgoingPath;
  }

  void updateVertexCenter(Offset updatedVertexCenter) {
    vertexCenter = updatedVertexCenter;
  }

  bool wasClicked(Offset clickedCoordinate) {
    double distanceFromCenter = calculateDistance(vertexCenter.dx,
        vertexCenter.dy, clickedCoordinate.dx, clickedCoordinate.dy);
    if (distanceFromCenter <= VERTEX_RADIUS) return true;
    return false;
  }

  double calculateDistance(double x0, double y0, double x1, double y1) {
    return sqrt(pow(x1 - x0, 2) + pow(y1 - y0, 2));
  }

  static Paint getVertexPaint() {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade600.withAlpha(PAINT_ALPHA)
      ..strokeWidth = VERTEX_PAINT_STROKE_WIDTH;
  }
}