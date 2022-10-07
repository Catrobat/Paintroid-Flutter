import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'brush_options_notifier.dart';

class BrushOptionsState {
  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color color;

  static final provider =
      StateNotifierProvider<BrushOptionsNotifier, BrushOptionsState>(
    (ref) => BrushOptionsNotifier(
      const BrushOptionsState(
        strokeWidth: 25,
        strokeCap: StrokeCap.round,
        color: Color(0xFF808080),
      ),
    ),
  );

  const BrushOptionsState({
    required this.strokeWidth,
    required this.strokeCap,
    required this.color,
  });

  BrushOptionsState copyWith({
    double? strokeWidth,
    StrokeCap? strokeCap,
    Color? color,
  }) {
    return BrushOptionsState(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeCap: strokeCap ?? this.strokeCap,
      color: color ?? this.color,
    );
  }
}
