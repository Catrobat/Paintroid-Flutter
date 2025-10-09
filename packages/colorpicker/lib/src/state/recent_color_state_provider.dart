import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_color_state_provider.g.dart';

const int _maxRecentColors = 6;

@Riverpod(keepAlive: true)
class RecentColors extends _$RecentColors {
  @override
  List<Color> build() {
    return [];
  }

  void addColor(Color color) {
    final currentState = List<Color>.from(state);
    currentState.removeWhere((existingColor) => existingColor == color);
    currentState.insert(0, color);

    if (currentState.length > _maxRecentColors) {
      state = currentState.sublist(0, _maxRecentColors);
    } else {
      state = currentState;
    }
  }
}
