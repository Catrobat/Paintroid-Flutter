import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_picker_state_data.freezed.dart';

@immutable
@freezed
class ColorPickerStateData with _$ColorPickerStateData {
  const factory ColorPickerStateData({
    required Color currentColor,
    required double currentOpacity,
  }) = _ColorPickerStateData;
}
