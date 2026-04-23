import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';
import 'package:paintroid/core/utils/color_utils.dart';

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.toValue();
}
