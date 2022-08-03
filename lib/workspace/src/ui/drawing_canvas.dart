import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';

import '../state/canvas_dirty_state.dart';
import '../state/canvas_state_notifier.dart';
import 'canvas_painter.dart';

class DrawingCanvas extends ConsumerStatefulWidget {
  const DrawingCanvas({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends ConsumerState<DrawingCanvas>
    with WidgetsBindingObserver {
  late final toolStateNotifier = ref.read(ToolState.provider.notifier);
  late final canvasStateNotifier = ref.read(CanvasState.provider.notifier);
  late final canvasDirtyNotifier = ref.read(CanvasDirtyState.provider.notifier);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: ref.watch(CanvasState.provider).size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(width: 0.5)),
        ),
        position: DecorationPosition.foreground,
        child: GestureDetector(
          onPanDown: (details) {
            final box = context.findRenderObject() as RenderBox;
            toolStateNotifier
                .didTapDown(box.globalToLocal(details.globalPosition));
          },
          onPanUpdate: (details) {
            final box = context.findRenderObject() as RenderBox;
            toolStateNotifier
                .didDrag(box.globalToLocal(details.globalPosition));
            canvasDirtyNotifier.repaint();
          },
          onPanEnd: (_) {
            toolStateNotifier.didTapUp();
            canvasStateNotifier.updateCachedImage();
          },
          child: const CanvasPainter(),
        ),
      ),
    );
  }
}
