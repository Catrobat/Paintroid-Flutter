import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/clipping_tool_state_provider.dart';

import 'package:path_drawing/path_drawing.dart';

class ClippingTool extends Tool {
  static const double _outerStrokeWidthOffset = 5.0;
  static const double _dashLengthMultiplier = 2.0;
  static const double _dashGapMultiplier = 2.0;

  final GraphicFactory graphicFactory;
  final ClippingToolState clippingToolState;
  final CanvasStateProvider canvasStateProvider;

  @visibleForTesting
  PathWithActionHistory? pathToDraw;

  ClippingTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required this.clippingToolState,
    required this.canvasStateProvider,
    super.type = ToolType.CLIPPING,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  @override
  void onDown(Offset point, Paint paint) {
    if (clippingToolState.hasActiveClipPath) {
      clippingToolState.clearClipPath();
      pathToDraw = null;
    }

    pathToDraw =
        graphicFactory.createPathWithActionHistory()
          ..moveTo(point.dx, point.dy);

    canvasStateProvider.resetCanvasWithExistingCommands();
  }

  @override
  void onDrag(Offset point, Paint paint) {
    pathToDraw?.lineTo(point.dx, point.dy);
  }

  @override
  Future<void> onUp(Offset point, Paint paint) async {
    final path = pathToDraw;
    if (path == null) {
      return;
    }

    if (path.actions.isNotEmpty) {
      final lastAction = path.actions.last;
      bool isSameAsLastPoint = false;

      if (lastAction is LineToAction) {
        isSameAsLastPoint =
            (lastAction.x == point.dx && lastAction.y == point.dy);
      } else if (lastAction is MoveToAction) {
        isSameAsLastPoint =
            (lastAction.x == point.dx && lastAction.y == point.dy);
      }

      if (!isSameAsLastPoint) {
        path.lineTo(point.dx, point.dy);
      }
    }

    if (path.actions.length <= 1) {
      pathToDraw = null;
      await canvasStateProvider.resetCanvasWithExistingCommands();
      return;
    }

    path.close();
    clippingToolState.setHasActiveClipPath(true);

    await canvasStateProvider.resetCanvasWithExistingCommands();
    await canvasStateProvider.updateCachedImage();
  }

  @override
  void onCancel() {}

  @override
  void onCheckmark(Paint paint) {
    final path = pathToDraw;
    if (path != null && path.actions.isNotEmpty) {
      final cropCommand = commandFactory.createClipAreaCommand(path, paint);
      commandManager.addGraphicCommand(cropCommand);

      clippingToolState.clearClipPath();
      pathToDraw = null;

      canvasStateProvider.resetCanvasWithExistingCommands();
    }
  }

  void draw(Canvas canvas, Paint paint) {
    final pathData = pathToDraw;
    if (pathData == null) return;

    final double baseStrokeWidth = paint.strokeWidth;
    final double outerStrokeWidth = baseStrokeWidth + _outerStrokeWidthOffset;

    final double dashLength = baseStrokeWidth * _dashLengthMultiplier;
    final double dashGap = baseStrokeWidth * _dashGapMultiplier;
    final dashArray = CircularIntervalList<double>([dashLength, dashGap]);

    final Color contrastColor =
        (paint.color.toARGB32() & 0x00FFFFFF) == 0
            ? Color(0xFFFFFFFF)
            : Color(0xFF000000);

    final borderPaint =
        Paint()
          ..color = contrastColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerStrokeWidth
          ..strokeCap = paint.strokeCap
          ..strokeJoin = paint.strokeJoin;

    final innerPaint =
        Paint()
          ..color = paint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = baseStrokeWidth
          ..strokeCap = paint.strokeCap
          ..strokeJoin = paint.strokeJoin;

    final path = Path()..addPath(pathData.path, Offset.zero);

    final dashedPath = dashPath(path, dashArray: dashArray);

    canvas.drawPath(dashedPath, borderPaint);
    canvas.drawPath(dashedPath, innerPaint);
  }

  @override
  void onPlus() {}

  @override
  void onRedo() {
    commandManager.redo();
    canvasStateProvider.resetCanvasWithExistingCommands();
  }

  @override
  void onUndo() {
    commandManager.undo();
    canvasStateProvider.resetCanvasWithExistingCommands();
  }
}
