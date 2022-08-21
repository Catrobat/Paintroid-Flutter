part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? backgroundImage;
  final Image? cachedImage;
  final Size size;

  static CanvasState get initial {
    final window = widgets.WidgetsBinding.instance.window;
    final obscuredOffset = Offset(
      window.viewPadding.left + window.viewPadding.right,
      Platform.isIOS ? window.viewPadding.top + window.viewPadding.bottom : 0,
    );
    final size = window.physicalSize - obscuredOffset as Size;
    return CanvasState(size: size);
  }

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
