// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'canvas_painter_provider.g.dart';

@riverpod
class CanvasPainterProvider extends _$CanvasPainterProvider {
  @override
  void build() {}

  void repaint() => ref.notifyListeners();
}
