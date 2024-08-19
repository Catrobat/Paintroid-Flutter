import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/enums/shape_type.dart';

part 'shapes_tool_options_state_data.freezed.dart';

@immutable
@freezed
class ShapesToolOptionsStateData with _$ShapesToolOptionsStateData {
  const factory ShapesToolOptionsStateData({
    required bool isRotating,
    required ShapeType shapeType,
  }) = _ShapesToolOptionsData;
}
