import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';

import '../state/canvas_dirty_state.dart';
import '../state/canvas_state_notifier.dart';
import '../state/workspace_state_notifier.dart';
import 'canvas_painter.dart';

class DrawingCanvas extends ConsumerStatefulWidget {
  const DrawingCanvas({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends ConsumerState<DrawingCanvas> {
  late final _toolStateNotifier = ref.read(ToolState.provider.notifier);
  late final _canvasStateNotifier = ref.read(CanvasState.provider.notifier);
  late final _canvasDirtyNotifier = ref.read(CanvasDirtyState.provider.notifier);

  final _canvasPainterKey = GlobalKey(debugLabel: "CanvasPainter");
  final _transformationController = TransformationController();
  var _pointersOnScreen = 0;
  var _isZooming = false;

  void _resetCanvasScale({bool fitToScreen = false}) {
    final box = context.findRenderObject() as RenderBox;
    final widgetCenterOffset = Alignment.center.alongSize(box.size);
    final scale = fitToScreen ? 1.0 : 0.85;
    final scaledMatrix = _transformationController.value.clone()
      ..setEntry(0, 0, scale)
      ..setEntry(1, 1, scale);
    _transformationController.value = scaledMatrix;
    final scaleAdjustedCenterOffset =
        _transformationController.toScene(widgetCenterOffset) -
            widgetCenterOffset;
    final centeredMatrix = _transformationController.value.clone()
      ..translate(scaleAdjustedCenterOffset.dx, scaleAdjustedCenterOffset.dy);
    _transformationController.value = centeredMatrix;
  }

  void _onPointerDown(PointerDownEvent _) {
    _pointersOnScreen++;
    if (_pointersOnScreen >= 2) {
      _isZooming = true;
      _toolStateNotifier.didSwitchToZooming();
    }
  }

  void _onPointerUp(PointerUpEvent _) {
    _pointersOnScreen--;
    if (_isZooming && _pointersOnScreen == 0) _isZooming = false;
  }

  Offset _globalToCanvas(Offset global) {
    final canvasBox = _canvasPainterKey.currentContext!.findRenderObject() as RenderBox;
    return canvasBox.globalToLocal(global);
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (!_isZooming) {
      _toolStateNotifier.didTapDown(_globalToCanvas(details.focalPoint));
    }
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    if (!_isZooming) {
      _toolStateNotifier.didDrag(_globalToCanvas(details.focalPoint));
      _canvasDirtyNotifier.repaint();
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    if (!_isZooming) {
      _toolStateNotifier.didTapUp();
      _canvasStateNotifier.updateCachedImage();
    }
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
    ref.listen<bool>(
      WorkspaceState.provider.select((state) => state.isFullscreen),
      (wasFullscreen, isFullscreen) {
        _resetCanvasScale(fitToScreen: isFullscreen);
      },
    );
    final canvasSize = ref.watch(
      CanvasState.provider.select((state) => state.size),
    );
    final panningMargin = (canvasSize - const Offset(5, 5)) as Size;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: InteractiveViewer(
        clipBehavior: Clip.none,
        transformationController: _transformationController,
        boundaryMargin: EdgeInsets.symmetric(
          horizontal: panningMargin.width,
          vertical: panningMargin.height,
        ),
        minScale: 0.2,
        maxScale: 6.9,
        panEnabled: false,
        onInteractionStart: _onInteractionStart,
        onInteractionUpdate: _onInteractionUpdate,
        onInteractionEnd: _onInteractionEnd,
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox.fromSize(
              key: _canvasPainterKey,
              size: canvasSize,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(width: 0.5)),
                ),
                position: DecorationPosition.foreground,
                child: CanvasPainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
