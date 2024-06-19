// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';

part 'paint_provider.g.dart';

@riverpod
class PaintProvider extends _$PaintProvider {
  Paint _copyWith({
    PaintingStyle? style,
    StrokeJoin? strokeJoin,
    Color? color,
    StrokeCap? strokeCap,
    double? strokeWidth,
    BlendMode? blendMode,
  }) {
    return Paint()
      ..style = style ?? state.style
      ..strokeJoin = strokeJoin ?? state.strokeJoin
      ..color = color ?? state.color
      ..strokeCap = strokeCap ?? state.strokeCap
      ..strokeWidth = strokeWidth ?? state.strokeWidth
      ..blendMode = blendMode ?? state.blendMode;
  }

  void updateStrokeWidth(double newStrokeWidth) {
    state = _copyWith(strokeWidth: newStrokeWidth);
  }

  void updateStrokeCap(StrokeCap newStrokeCap) {
    state = _copyWith(strokeCap: newStrokeCap);
  }

  void updateColor(Color newColor) {
    state = _copyWith(color: newColor);
  }

  void updateBlendMode(BlendMode newMode) {
    state = _copyWith(blendMode: newMode);
  }

  @override
  Paint build() {
    return ref.watch(graphicFactoryProvider).createPaint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xff00abbb)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
  }
}
