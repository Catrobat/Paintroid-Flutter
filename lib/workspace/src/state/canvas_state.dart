part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? cachedImage;
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
    this.cachedImage,
    required this.size,
  });

  CanvasState copyWith({
    Option<Image>? cachedImage,
    Size? size,
  }) {
    return CanvasState(
      cachedImage:
          cachedImage != null ? cachedImage.toNullable() : this.cachedImage,
      size: size ?? this.size,
    );
  }
}
