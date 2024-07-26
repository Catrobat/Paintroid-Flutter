import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/canvas_painter.dart';

class DrawingCanvas extends ConsumerStatefulWidget {
  const DrawingCanvas({super.key});

  @override
  ConsumerState<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends ConsumerState<DrawingCanvas> {
  late final _toolBoxStateNotifier = ref.read(toolBoxStateProvider.notifier);
  late final _canvasStateNotifier = ref.read(canvasStateProvider.notifier);

  final _canvasPainterKey = GlobalKey(debugLabel: 'CanvasPainter');
  final _transformationController = TransformationController();
  var _pointersOnScreen = 0;
  var _isZooming = false;
  Offset _lastPointerUpPosition = Offset.zero;

  void _resetCanvasScale({bool fitToScreen = false}) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
          ..translate(
              scaleAdjustedCenterOffset.dx, scaleAdjustedCenterOffset.dy);
        _transformationController.value = centeredMatrix;
      });

  void _onPointerDown(PointerDownEvent _) {
    _pointersOnScreen++;
    if (_pointersOnScreen >= 2) {
      _isZooming = true;
      _toolBoxStateNotifier.didSwitchToZooming();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _pointersOnScreen--;
    _lastPointerUpPosition = event.position;
    if (_isZooming && _pointersOnScreen == 0) _isZooming = false;
  }

  Offset _globalToCanvas(Offset global) {
    final canvasBox =
        _canvasPainterKey.currentContext!.findRenderObject() as RenderBox;
    return canvasBox.globalToLocal(global);
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (!_isZooming) {
      if (details.pointerCount == 1) {
        _toolBoxStateNotifier.didTapDown(_globalToCanvas(details.focalPoint));
      }
    }
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    if (!_isZooming) {
      if (details.pointerCount == 1) {
        _toolBoxStateNotifier.didDrag(_globalToCanvas(details.focalPoint));
        ref.read(canvasPainterProvider.notifier).repaint();
      }
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    if (!_isZooming) {
      _toolBoxStateNotifier.didTapUp(_globalToCanvas(_lastPointerUpPosition));
      ref.read(canvasPainterProvider.notifier).repaint();
      final currentTool = ref.read(toolBoxStateProvider).currentTool;
      switch (currentTool.type) {
        case ToolType.LINE:
          _canvasStateNotifier.resetCanvasWithExistingCommands();
          break;
        default:
          _canvasStateNotifier.updateCachedImage();
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _resetCanvasScale();
  }

  @override
  void didUpdateWidget(covariant DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetCanvasScale();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(
      workspaceStateProvider.select((state) => state.isFullscreen),
      (wasFullscreen, isFullscreen) {
        _resetCanvasScale(fitToScreen: isFullscreen);
      },
    );
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: InteractiveViewer(
        clipBehavior: Clip.none,
        transformationController: _transformationController,
        minScale: 0.2,
        maxScale: 100,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        interactionEndFrictionCoefficient: double.minPositive,
        panEnabled:
            ref.watch(toolBoxStateProvider).currentTool.type == ToolType.HAND,
        onInteractionStart: _onInteractionStart,
        onInteractionUpdate: _onInteractionUpdate,
        onInteractionEnd: _onInteractionEnd,
        child: Center(
          child: ref.watch(IDeviceService.sizeProvider).map(
                data: (_) => FittedBox(
                  fit: BoxFit.contain,
                  child: CanvasPainter(key: _canvasPainterKey),
                ),
                error: (_) => Container(),
                loading: (_) => Container(),
              ),
        ),
      ),
    );
  }
}
