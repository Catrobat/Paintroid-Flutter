part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  const CanvasState({
    required this.width,
    required this.height,
  }) : aspectRatio = width / height;

  final double width;
  final double height;
  final double aspectRatio;

  CanvasState copyWith({
    double? width,
    double? height,
  }) {
    return CanvasState(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
