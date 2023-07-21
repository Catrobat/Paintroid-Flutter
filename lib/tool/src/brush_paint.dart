import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/tool/src/brush_paint_notifier.dart';

@immutable
class BrushPaintState {
  const BrushPaintState({required this.paint});

  final Paint paint;

  static final provider =
      StateNotifierProvider<BrushPaintNotifier, BrushPaintState>(
    (ref) => BrushPaintNotifier(
      BrushPaintState(
        paint: ref.watch(GraphicFactory.provider).createPaint()
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..color = const Color(0xFF830000)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 25,
      ),
    ),
  );

  BrushPaintState copyWith({Paint? paint}) {
    return BrushPaintState(paint: paint ?? this.paint);
  }
}
