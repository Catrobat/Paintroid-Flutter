// Flutter imports:
import 'package:flutter/painting.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brush_tool_state_data.freezed.dart';

@immutable
@freezed
class BrushToolStateData with _$BrushToolStateData {
  const factory BrushToolStateData({
    required Paint paint,
  }) = _BrushToolStateData;
}
