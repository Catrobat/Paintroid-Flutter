import 'dart:ui';

import 'package:command/command.dart';
import 'package:flutter/widgets.dart';
import 'package:tools/tools.dart';

class LineCommand extends GraphicCommand {
  LineCommand(
    this.path,
    super.paint,
    this.startPoint,
    this.endPoint,
  );

  PathWithActionHistory path;
  Offset startPoint;
  Offset endPoint;
  bool isSourcePath = false;

  @override
  void call(Canvas canvas) {
    canvas.drawPath(path, paint);
  }

  @override
  List<Object?> get props => [paint, path];

  void drawVertices(Canvas canvas, VertexStack vertexStack) {
    for (var vertex in vertexStack) {
      canvas.drawCircle(
          vertex.vertexCenter, Vertex.VERTEX_RADIUS, Vertex.getVertexPaint());
    }
  }

  void setAsSourcePath() {
    isSourcePath = true;
  }

  void updatePath(PathWithActionHistory newPath) {
    path = newPath;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
