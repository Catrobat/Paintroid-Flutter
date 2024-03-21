import 'package:colorpicker/src/state/color_picker_state_data.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:colorpicker/src/constants/colors.dart';

part 'color_picker_state_provider.g.dart';

@riverpod
class ColorPickerState extends _$ColorPickerState {
  final colors = DisplayColors.colors;
  @override
  ColorPickerStateData build() {
    return ColorPickerStateData(
      currentColor: colors[0],
      currentOpacity: 1.0,
    );
  }

  void updateColor(Color newColor) {
    state = state.copyWith(currentColor: newColor);
  }

  void updateOpacity(double newOpacity) {
    state = state.copyWith(currentOpacity: newOpacity);
  }
}
