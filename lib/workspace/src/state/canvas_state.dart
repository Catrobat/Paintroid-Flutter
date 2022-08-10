part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? backgroundImage;
  final Image? cachedImage;
  final Size size;
  final double scale;

  static const initial = CanvasState(size: Size(1080, 1920));

  static final provider =
      StateNotifierProvider<CanvasStateNotifier, CanvasState>(
    (ref) {
      return CanvasStateNotifier(
        initial,
        ref.watch(CommandManager.provider),
        ref.watch(GraphicFactory.provider),
      );
    },
  );

  const CanvasState({
    this.backgroundImage,
    this.cachedImage,
    this.scale = 0.85,
    required this.size,
  });

  CanvasState copyWith({
    Option<Image>? backgroundImage,
    Option<Image>? cachedImage,
    Size? size,
    double? scale,
  }) {
    return CanvasState(
      backgroundImage: backgroundImage != null
          ? backgroundImage.toNullable()
          : this.backgroundImage,
      cachedImage:
          cachedImage != null ? cachedImage.toNullable() : this.cachedImage,
      size: size ?? this.size,
      scale: scale ?? this.scale,
    );
  }
}
