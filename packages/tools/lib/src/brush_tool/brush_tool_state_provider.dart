// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:command/graphic_factory/graphic_factory_provider.dart';
import 'package:component_library/component_library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:tools/tools.dart';

part 'brush_tool_state_provider.g.dart';

@riverpod
class BrushToolState extends _$BrushToolState {
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

  void updateBlendMode(BlendMode newMode) {
    Paint newPaint = state.paint..blendMode = newMode;
    state = state.copyWith(paint: newPaint);
  }

  @override
  BrushToolStateData build() {
    return BrushToolStateData(
      paint: ref.watch(graphicFactoryProvider).createPaint()
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..color = CustomColors.shadow
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 25,
    );
  }
}
