import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_state.g.dart';

@riverpod
class ColorStateNotifier extends _$ColorStateNotifier {
  @override
  Color build() {
    return Colors.blue;
  }

  void updateColor(Color newColor) {
    state = newColor;
  }
}
