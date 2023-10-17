import 'dart:ui';

import 'package:component_library/src/models/path_with_action_history.dart';

class GraphicFactory {
  const GraphicFactory();

  Paint createPaint() => Paint();

  PathWithActionHistory createPathWithActionHistory() =>
      PathWithActionHistory();

  PictureRecorder createPictureRecorder() => PictureRecorder();

  Canvas createCanvasWithRecorder(PictureRecorder recorder) => Canvas(recorder);

  Paint copyPaint(Paint original) {
    return Paint()
      ..blendMode = original.blendMode
      ..color = original.color
      ..colorFilter = original.colorFilter
      ..filterQuality = original.filterQuality
      ..imageFilter = original.imageFilter
      ..invertColors = original.invertColors
      ..isAntiAlias = original.isAntiAlias
      ..maskFilter = original.maskFilter
      ..shader = original.shader
      ..strokeCap = original.strokeCap
      ..strokeJoin = original.strokeJoin
      ..strokeMiterLimit = original.strokeMiterLimit
      ..strokeWidth = original.strokeWidth
      ..style = original.style;
  }
}
