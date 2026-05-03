import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/canvas_painter.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/magnifier_glass.dart';

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
  final _focalPointNotifier = ValueNotifier<Offset>(Offset.zero);
  var _pointersOnScreen = 0;
  var _isZooming = false;
  var _wasZooming = false;
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
          ..translateByDouble(
              scaleAdjustedCenterOffset.dx, scaleAdjustedCenterOffset.dy,0.0,1.0);
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
    if (_isZooming && _pointersOnScreen == 0) {
      _wasZooming = true;
      _isZooming = false;
    }

    if (_pointersOnScreen == 0 &&
        ref.read(toolBoxStateProvider).currentTool.type == ToolType.PIPETTE) {
      _toolBoxStateNotifier.didTapUp(_globalToCanvas(_lastPointerUpPosition));
    }
  }

  Offset _globalToCanvas(Offset global) {
    final canvasBox =
        _canvasPainterKey.currentContext!.findRenderObject() as RenderBox;
    return canvasBox.globalToLocal(global);
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (!_isZooming) {
      if (details.pointerCount == 1) {
        _focalPointNotifier.value = details.localFocalPoint;
        _toolBoxStateNotifier.didTapDown(_globalToCanvas(details.focalPoint));
      }
    }
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    if (!_isZooming) {
      if (details.pointerCount == 1) {
        _focalPointNotifier.value = details.localFocalPoint;
        _toolBoxStateNotifier.didDrag(_globalToCanvas(details.focalPoint));
        ref.read(canvasPainterProvider.notifier).repaint();
      }
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    if (_wasZooming) {
      _wasZooming = false;
      return;
    }
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
  void dispose() {
    _focalPointNotifier.dispose();
    super.dispose();
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
      onPointerDown: (event) {
        _onPointerDown(event);
        if (!_isZooming &&
            ref.read(toolBoxStateProvider).currentTool.type ==
                ToolType.PIPETTE) {
          _focalPointNotifier.value = event.localPosition;
          _toolBoxStateNotifier.didTapDown(_globalToCanvas(event.position));
        }
      },
      onPointerMove: (event) {
        if (!_isZooming &&
            ref.read(toolBoxStateProvider).currentTool.type ==
                ToolType.PIPETTE) {
          _focalPointNotifier.value = event.localPosition;
          _toolBoxStateNotifier.didDrag(_globalToCanvas(event.position));
          ref.read(canvasPainterProvider.notifier).repaint();
        }
      },
      onPointerUp: _onPointerUp,
      child: MagnifierGlass(
        focalPointNotifier: _focalPointNotifier,
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          transformationController: _transformationController,
          minScale: 0.2,
          maxScale: 100,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          interactionEndFrictionCoefficient: double.minPositive,
          panEnabled:
              ref.watch(toolBoxStateProvider).currentTool.type == ToolType.HAND,
          onInteractionStart: (details) {
            if (ref.read(toolBoxStateProvider).currentTool.type !=
                ToolType.PIPETTE) {
              _onInteractionStart(details);
            }
          },
          onInteractionUpdate: (details) {
            if (ref.read(toolBoxStateProvider).currentTool.type !=
                ToolType.PIPETTE) {
              _onInteractionUpdate(details);
            }
          },
          onInteractionEnd: (details) {
            if (ref.read(toolBoxStateProvider).currentTool.type !=
                ToolType.PIPETTE) {
              _onInteractionEnd(details);
            }
          },
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
      ),
    );
  }
}
