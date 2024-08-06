import 'dart:ui';

import 'package:paintroid/core/commands/path_with_action_history.dart';

class GraphicFactory {
  const GraphicFactory();

  Paint createPaint() => Paint();

  static Paint guidePaint = Paint()
    ..color = const Color.fromARGB(121, 55, 55, 55)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  static Paint anchorPaint = Paint()
    ..color = const Color.fromARGB(220, 117, 117, 117)
    ..style = PaintingStyle.fill;

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

  static Paint copyPaintWith({
    required Paint original,
    BlendMode? blendMode,
    Color? color,
    ColorFilter? colorFilter,
    FilterQuality? filterQuality,
    ImageFilter? imageFilter,
    bool? invertColors,
    bool? isAntiAlias,
    MaskFilter? maskFilter,
    Shader? shader,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
    double? strokeMiterLimit,
    double? strokeWidth,
    PaintingStyle? style,
  }) {
    return Paint()
      ..blendMode = blendMode ?? original.blendMode
      ..color = color ?? original.color
      ..colorFilter = colorFilter ?? original.colorFilter
      ..filterQuality = filterQuality ?? original.filterQuality
      ..imageFilter = imageFilter ?? original.imageFilter
      ..invertColors = invertColors ?? original.invertColors
      ..isAntiAlias = isAntiAlias ?? original.isAntiAlias
      ..maskFilter = maskFilter ?? original.maskFilter
      ..shader = shader ?? original.shader
      ..strokeCap = strokeCap ?? original.strokeCap
      ..strokeJoin = strokeJoin ?? original.strokeJoin
      ..strokeMiterLimit = strokeMiterLimit ?? original.strokeMiterLimit
      ..strokeWidth = strokeWidth ?? original.strokeWidth
      ..style = style ?? original.style;
  }
}
