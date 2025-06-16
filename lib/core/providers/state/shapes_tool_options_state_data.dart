import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/enums/shape_type.dart';

part 'shapes_tool_options_state_data.freezed.dart';

@immutable
@freezed
class ShapesToolOptionsStateData with _$ShapesToolOptionsStateData {
  const factory ShapesToolOptionsStateData({
    required ShapeType shapeType,
    required ShapeStyle shapeStyle,
  }) = _ShapesToolOptionsData;
}
