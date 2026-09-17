import 'dart:ui';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paint_provider.g.dart';

@Riverpod(keepAlive: true)
class PaintProvider extends _$PaintProvider {
  @override
  Paint build() {
    ref.listen(
      advancedSettingsProvider.select((settings) => settings.isAntialiasingEnabled),
      (_, isAntialiasingEnabled) => updateAntialiasing(isAntialiasingEnabled),
    );

    return _createDefaultStrokePaint();
  }

  Paint _createDefaultStrokePaint() {
    const double strokeWidth = 25.0;
    return ref.watch(graphicFactoryProvider).createPaint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xff00abbb)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = _resolveAntiAlias(
        strokeWidth: strokeWidth,
        isAntialiasingEnabled:
            ref.read(advancedSettingsProvider).isAntialiasingEnabled,
      );
  }

  Paint get currentState => state;

  static bool _resolveAntiAlias({
    required double strokeWidth,
    required bool isAntialiasingEnabled,
  }) {
    return strokeWidth <= 1.0 ? false : isAntialiasingEnabled;
  }

  void updateStrokeWidth(double newStrokeWidth) {
    state = GraphicFactory.copyPaintWith(
      original: state,
      strokeWidth: newStrokeWidth,
      isAntiAlias: _resolveAntiAlias(
        strokeWidth: newStrokeWidth,
        isAntialiasingEnabled:
            ref.read(advancedSettingsProvider).isAntialiasingEnabled,
      ),
    );
  }

  void updateAntialiasing(bool isAntialiasingEnabled) {
    state = GraphicFactory.copyPaintWith(
      original: state,
      isAntiAlias: _resolveAntiAlias(
        strokeWidth: state.strokeWidth,
        isAntialiasingEnabled: isAntialiasingEnabled,
      ),
    );
  }

  void updateStrokeCap(StrokeCap newStrokeCap) {
    state = GraphicFactory.copyPaintWith(
      original: state,
      strokeCap: newStrokeCap,
    );
  }

  void updateColor(Color newColor) {
    state = GraphicFactory.copyPaintWith(original: state, color: newColor);
  }

  void updateBlendMode(BlendMode newMode) {
    state = GraphicFactory.copyPaintWith(original: state, blendMode: newMode);
  }

  void updateBlendModeByToolType(ToolType toolType) {
    switch (toolType) {
      case ToolType.ERASER:
        updateBlendMode(BlendMode.clear);
        break;
      default:
        updateBlendMode(BlendMode.srcOver);
        break;
    }
  }
}
