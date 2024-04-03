// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:io_library/io_library.dart';

class PaintConverter implements JsonConverter<Paint, Map<String, dynamic>> {
  const PaintConverter();

  @override
  Paint fromJson(Map<String, dynamic> json) {
    Paint paint = Paint();

    int version = json['version'] as int;
    if (version >= Version.v1) {
      paint.color = Color(json['color']);
      paint.strokeWidth = json['strokeWidth'];
      paint.strokeCap = StrokeCap.values[json['strokeCap']];
      paint.isAntiAlias = json['isAntiAlias'];
      paint.style = PaintingStyle.values[json['style']];
      paint.strokeJoin = StrokeJoin.values[json['strokeJoin']];
      paint.blendMode = BlendMode.values[json['blendMode']];
    }
    if (version >= Version.v2) {
      // paint.newAttribute = json['newAttribute'];
    }
    return paint;
  }

  // Never remove attributes, it will cause errors in older versions!!
  // Only add new attributes at the end of the map and increase the version number.
  @override
  Map<String, dynamic> toJson(Paint paint) {
    Map<String, dynamic> json = <String, dynamic>{};
    if (SerializerVersion.PAINT_VERSION >= Version.v1) {
      json['version'] = SerializerVersion.PAINT_VERSION;
      json['color'] = paint.color.value;
      json['strokeWidth'] = paint.strokeWidth;
      json['strokeCap'] = paint.strokeCap.index;
      json['isAntiAlias'] = paint.isAntiAlias;
      json['style'] = paint.style.index;
      json['strokeJoin'] = paint.strokeJoin.index;
      json['blendMode'] = paint.blendMode.index;
    }
    if (SerializerVersion.PAINT_VERSION >= Version.v2) {
      // json['newAttribute'] = paint.newAttribute;
    }

    return json;
  }
}
