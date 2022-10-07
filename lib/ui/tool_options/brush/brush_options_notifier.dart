import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'brush_options_state.dart';

class BrushOptionsNotifier extends StateNotifier<BrushOptionsState> {
  BrushOptionsNotifier(super.state);

  late final widthTextController = TextEditingController(
    text: "${state.strokeWidth.toInt()}",
  );

  void onCapChanged(StrokeCap cap) {
    state = state.copyWith(strokeCap: cap);
  }

  void onWidthTextChanged(String text) {
    if (text.isEmpty) return;
    _changeStrokeWidth(double.parse(text));
  }

  void onWidthTextSubmitted(String text) {
    if (text.isNotEmpty) return;
    widthTextController.text = state.strokeWidth.toInt().toString();
  }

  void onWidthSliderChanged(double newWidth) {
    _changeStrokeWidth(newWidth);
    widthTextController.text = newWidth.toInt().toString();
  }

  void _changeStrokeWidth(double width) {
    state = state.copyWith(strokeWidth: width);
  }
}
