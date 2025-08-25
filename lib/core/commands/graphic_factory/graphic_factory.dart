import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';

class GraphicFactory {
  const GraphicFactory();

  Paint createPaint() => Paint();

  static Paint guidePaint = Paint()
    ..color = const Color.fromARGB(121, 55, 55, 55)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  static final Paint boundingBoxRectPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 11.0;

  static final Paint boundingBoxTransparentPaint = Paint()
    ..color = Colors.transparent
    ..style = PaintingStyle.stroke;

  static final Paint boundingBoxHandlePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 16.0
    ..strokeCap = StrokeCap.square
    ..strokeJoin = StrokeJoin.bevel
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke;

  static final Paint boundingBoxRotationHandlePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 20
    ..strokeCap = StrokeCap.round;

  static Paint createFillPaint(Paint basePaint) {
    return Paint()
      ..color = basePaint.color.withAlpha(255)
      ..style = PaintingStyle.fill
      ..strokeWidth = basePaint.strokeWidth;
  }

  static Paint createStrokePaint(Paint basePaint) {
    return Paint()
      ..color = basePaint.color.withAlpha(255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = basePaint.strokeWidth
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;
  }

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
