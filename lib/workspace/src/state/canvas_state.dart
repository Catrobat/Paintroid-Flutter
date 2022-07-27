part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? lastRenderedImage;
  final Size size;

  static const initial = CanvasState(size: Size.zero);

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
    this.lastRenderedImage,
    required this.size,
  });

  CanvasState copyWith({
    Nullable<Image>? lastRenderedImage,
    Size? size,
  }) {
    return CanvasState(
      lastRenderedImage: lastRenderedImage != null
          ? lastRenderedImage.value
          : this.lastRenderedImage,
      size: size ?? this.size,
    );
  }
}
