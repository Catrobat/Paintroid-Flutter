import 'dart:ui';

import 'package:paintroid/core/path_with_action_history.dart';

class GraphicFactory {
  const GraphicFactory();

  Paint createPaint() => Paint();

  PathWithActionHistory createPathWithActionHistory() =>
      PathWithActionHistory();

  PictureRecorder createPictureRecorder() => PictureRecorder();

  Canvas createCanvasWithRecorder(PictureRecorder recorder) => Canvas(recorder);
}
