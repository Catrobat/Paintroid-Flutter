part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? backgroundImage;
  final Image? cachedImage;
  final Size size;

  static var _initial = const CanvasState(size: Size.zero);

  static CanvasState get initial => _initial;

  static final provider =
      StateNotifierProvider<CanvasStateNotifier, CanvasState>(
    (ref) {
      final canvasSize = ref.watch(IDeviceService.sizeProvider).when(
            data: (size) => size,
            error: (_, __) => widgets.WidgetsBinding.instance.platformDispatcher
                .views.first.physicalSize,
            loading: () => Size.zero,
          );
      _initial = CanvasState(size: canvasSize);
      return CanvasStateNotifier(
        _initial,
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
