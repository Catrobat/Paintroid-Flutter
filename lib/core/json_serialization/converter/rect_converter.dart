
import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

class RectConverter implements JsonConverter<Rect, Map<String, dynamic>> {
  const RectConverter();

  @override
  Rect fromJson(Map<String, dynamic> json) {
    int version = json['version'] as int;
    if (version >= Version.v1) {
      double left = json['left'];
      double top = json['top'];
      double right = json['right'];
      double bottom = json['bottom'];
      return Rect.fromLTRB(left, top, right, bottom);
    }
    // Handle future versions if needed
    // if (version >= Version.v2) {
    //   // Additional attributes
    // }
    throw UnimplementedError('Unsupported version: $version');
  }

  @override
  Map<String, dynamic> toJson(Rect rect) {
    Map<String, dynamic> json = <String, dynamic>{};
    if (SerializerVersion.RECT_VERSION >= Version.v1) {
      json['version'] = SerializerVersion.RECT_VERSION;
      json['left'] = rect.left;
      json['top'] = rect.top;
      json['right'] = rect.right;
      json['bottom'] = rect.bottom;
    }
    // Handle future versions if needed
    // if (SerializerVersion.RECT_VERSION >= Version.v2) {
    //   // Additional attributes
    // }
    return json;
  }
}