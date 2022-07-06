part of 'workspace_state_notifier.dart';

@immutable
class CanvasState {
  const CanvasState({
    required this.aspectRatio,
    required this.width,
  });

  final double aspectRatio;
  final double width;

  CanvasState copyWith({
    double? aspectRatio,
    double? width,
  }) {
    return CanvasState(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      width: width ?? this.width,
    );
  }
}
