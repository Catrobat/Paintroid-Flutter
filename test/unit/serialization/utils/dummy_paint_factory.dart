import 'package:flutter/material.dart';

import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

class DummyPaintFactory {
  static Paint createPaint({int version = Version.v1}) {
    Paint paint = Paint();
    if (version >= Version.v1) {
      paint.color = Colors.blue;
      paint.strokeWidth = 5.0;
      paint.strokeCap = StrokeCap.round;
      paint.isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.strokeJoin = StrokeJoin.bevel;
      paint.blendMode = BlendMode.clear;
    }
    if (version >= Version.v2) {
      // paint.newAttribute = newAttribute;
    }
    return paint;
  }

  static bool comparePaint(Paint paint1, Paint paint2,
      {int version = Version.v1}) {
    bool result = true;
    if (version >= Version.v1) {
      result = paint1.color == paint2.color &&
          paint1.strokeWidth == paint2.strokeWidth &&
          paint1.strokeCap == paint2.strokeCap &&
          paint1.isAntiAlias == paint2.isAntiAlias &&
          paint1.style == paint2.style &&
          paint1.strokeJoin == paint2.strokeJoin &&
          paint1.blendMode == paint2.blendMode;
    }
    if (version >= Version.v2) {
      // result = result && paint1.newAttribute == paint2.newAttribute;
    }
    return result;
  }
}
