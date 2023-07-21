import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/src/brush_paint.dart';

class BrushPaintNotifier extends StateNotifier<BrushPaintState> {
  BrushPaintNotifier(super.state);

  void updateStrokeWidth(double newStrokeWidth) {
    Paint newPaint = state.paint..strokeWidth = newStrokeWidth;
    state = state.copyWith(paint: newPaint);
  }

  void updateStrokeCap(StrokeCap newStrokeCap) {
    Paint newPaint = state.paint..strokeCap = newStrokeCap;
    state = state.copyWith(paint: newPaint);
  }

  void updateColor(Color newColor) {
    Paint newPaint = state.paint..color = newColor;
    state = state.copyWith(paint: newPaint);
  }
}
