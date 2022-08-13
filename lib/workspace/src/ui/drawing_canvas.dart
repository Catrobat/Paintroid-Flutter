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

class _DrawingCanvasState extends ConsumerState<DrawingCanvas> {
  final _transformationController = TransformationController();

  void _resetCanvasScale() {
    final box = context.findRenderObject() as RenderBox;
    final widgetCenterOffset = Alignment.center.alongSize(box.size);
    final scaledMatrix = _transformationController.value.clone()..scale(0.85);
    _transformationController.value = scaledMatrix;
    final scaleAdjustedCenterOffset =
        _transformationController.toScene(widgetCenterOffset) -
            widgetCenterOffset;
    final centeredMatrix = _transformationController.value.clone()
      ..translate(scaleAdjustedCenterOffset.dx, scaleAdjustedCenterOffset.dy);
    _transformationController.value = centeredMatrix;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resetCanvasScale());
  }

  @override
  void didUpdateWidget(covariant DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetCanvasScale();
  }

  @override
  Widget build(BuildContext context) {
    final toolStateNotifier = ref.watch(ToolState.provider.notifier);
    final canvasStateNotifier = ref.watch(CanvasState.provider.notifier);
    final canvasDirtyNotifier = ref.watch(CanvasDirtyState.provider.notifier);
    final canvasSize = ref.watch(CanvasState.provider).size;
    final panningMargin = (canvasSize - const Offset(5, 5)) as Size;
    return InteractiveViewer(
      clipBehavior: Clip.none,
      transformationController: _transformationController,
      boundaryMargin: EdgeInsets.symmetric(
        horizontal: panningMargin.width,
        vertical: panningMargin.height,
      ),
      minScale: 0.2,
      maxScale: 6.9,
      panEnabled: false,
      onInteractionStart: (details) {
        final transformedLocalPoint = _transformationController.toScene(
          details.localFocalPoint,
        );
        if (details.pointerCount < 2) {
          toolStateNotifier.didTapDown(transformedLocalPoint);
        }
      },
      onInteractionUpdate: (details) {
        if (details.pointerCount < 2) {
          final transformedLocalPoint = _transformationController.toScene(
            details.localFocalPoint,
          );
          toolStateNotifier.didDrag(transformedLocalPoint);
          canvasDirtyNotifier.repaint();
        }
      },
      onInteractionEnd: (details) {
        if (details.pointerCount < 1) {
          toolStateNotifier.didTapUp();
          canvasStateNotifier.updateCachedImage();
        }
      },
      child: SizedBox.fromSize(
        size: canvasSize,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(width: 0.5)),
          ),
          position: DecorationPosition.foreground,
          child: CanvasPainter(),
        ),
      ),
    );
  }
}
