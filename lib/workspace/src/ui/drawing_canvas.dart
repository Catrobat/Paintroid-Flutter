import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/workspace/src/state/canvas_state_notifier.dart';
import 'package:paintroid/workspace/src/state/workspace_state_notifier.dart';

import '../state/canvas_dirty_state.dart';
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

  void _updateCanvasSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox;
      ref.read(CanvasState.provider.notifier).updateCanvasSize(renderBox.size);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateCanvasSize();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Size>(
      WorkspaceState.provider.select((value) => value.exportSize),
      (previous, next) {
        if (previous != next) {
          _updateCanvasSize();
        }
      },
    );
    return AspectRatio(
      aspectRatio: ref
          .watch(WorkspaceState.provider.select((state) => state.exportSize))
          .aspectRatio,
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
