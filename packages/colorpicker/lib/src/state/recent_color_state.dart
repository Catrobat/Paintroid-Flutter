import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _maxRecentColors = 7;

class RecentColorsNotifier extends StateNotifier<List<Color>> {
  RecentColorsNotifier() : super([]);

  void addColor(Color color) {
    if (state.isNotEmpty && state.first == color) {
      return;
    }

    final newList = [color, ...state];
    if (newList.length > _maxRecentColors) {
      state = newList.sublist(0, _maxRecentColors);
    } else {
      state = newList;
    }
  }
}

final recentColorsProvider =
    StateNotifierProvider<RecentColorsNotifier, List<Color>>((ref) {
  return RecentColorsNotifier();
});
