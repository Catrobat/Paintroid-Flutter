// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(json['dx'] as double, json['dy'] as double);
  }

  @override
  Map<String, dynamic> toJson(Offset offset) {
    return <String, dynamic>{
      'dx': offset.dx,
      'dy': offset.dy,
    };
  }
}
