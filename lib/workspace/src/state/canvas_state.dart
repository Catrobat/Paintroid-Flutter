part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? backgroundImage;
  final Image? cachedImage;
  final Size size;

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
    required this.size,
  });

  CanvasState copyWith({
    Option<Image>? backgroundImage,
    Option<Image>? cachedImage,
    Size? size,
  }) {
    return CanvasState(
      backgroundImage: backgroundImage != null
          ? backgroundImage.toNullable()
          : this.backgroundImage,
      cachedImage:
          cachedImage != null ? cachedImage.toNullable() : this.cachedImage,
      size: size ?? this.size,
    );
  }
}
