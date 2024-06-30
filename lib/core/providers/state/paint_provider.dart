import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/enums/tool_types.dart';

part 'paint_provider.g.dart';

@Riverpod(keepAlive: true)
class PaintProvider extends _$PaintProvider {
  @override
  Paint build() {
    return ref.watch(graphicFactoryProvider).createPaint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xff00abbb)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
  }

  void updateStrokeWidth(double newStrokeWidth) {
    state = GraphicFactory.copyPaintWith(
      original: state,
      strokeWidth: newStrokeWidth,
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
