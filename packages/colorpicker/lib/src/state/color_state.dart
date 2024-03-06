import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:colorpicker/src/constants/colors.dart';

part 'color_state.g.dart';

@riverpod
class ColorState extends _$ColorState {
  final colors = DisplayColors.colors;
  @override
  Color build() {
    return colors[0];
  }

  void updateColor(Color newColor) {
    state = newColor;
  }
}
