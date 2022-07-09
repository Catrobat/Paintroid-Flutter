import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'canvas_state.dart';

class CanvasStateNotifier extends StateNotifier<CanvasState> {
  CanvasStateNotifier(super.state);

  static final provider =
      StateNotifierProvider<CanvasStateNotifier, CanvasState>(
    (ref) => CanvasStateNotifier(
      const CanvasState(width: 1080, height: 1920),
    ),
  );

  void setCanvasSize(double width, double height) =>
      state = state.copyWith(width: width, height: height);
}
