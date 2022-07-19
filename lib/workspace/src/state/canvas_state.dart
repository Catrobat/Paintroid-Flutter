part of 'canvas_state_notifier.dart';

@immutable
class CanvasState {
  final Image? lastCompiledImage;
  final Size size;

  static const initial = CanvasState(size: Size.zero);

  static final provider =
      StateNotifierProvider<CanvasStateNotifier, CanvasState>(
    (ref) => CanvasStateNotifier(
      initial,
      ref.watch(CommandManager.provider),
      ref.watch(GraphicFactory.provider),
    ),
  );

  const CanvasState({
    this.lastCompiledImage,
    required this.size,
  });

  CanvasState copyWith({
    Image? lastCompiledImage,
    Size? size,
  }) {
    return CanvasState(
      lastCompiledImage: lastCompiledImage ?? this.lastCompiledImage,
      size: size ?? this.size,
    );
  }
}
