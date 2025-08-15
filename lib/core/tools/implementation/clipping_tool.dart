import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/enums/tool_types.dart';

class ClippingTool extends Tool {
  final GraphicFactory graphicFactory;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;
  Offset? _startPoint;

  ClippingTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    super.type = ToolType.CLIPPING,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  @override
  void onDown(Offset point, Paint paint) {
    _startPoint = point;
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);

    final dashedCommand =
    commandFactory.createClipPathCommand(pathToDraw, paint);
    commandManager.addGraphicCommand(dashedCommand);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset point, Paint paint) {
    commandManager.discardLastCommand();

    bool pointAddedInUp = false;
    if (pathToDraw.actions.isNotEmpty) {
      final lastAction = pathToDraw.actions.last;
      bool isSameAsLastPoint = false;

      if (lastAction is LineToAction) {
        isSameAsLastPoint =
        (lastAction.x == point.dx && lastAction.y == point.dy);
      } else if (lastAction is MoveToAction && pathToDraw.actions.length == 1) {
        isSameAsLastPoint =
        (lastAction.x == point.dx && lastAction.y == point.dy);
      }

      if (!isSameAsLastPoint) {
        pathToDraw.lineTo(point.dx, point.dy);
        pointAddedInUp = true;
      }
    } else {
      pathToDraw.moveTo(point.dx, point.dy);
      pathToDraw.lineTo(point.dx, point.dy);
      pointAddedInUp = true;
    }

    Offset currentEndPoint = point;
    if (pathToDraw.actions.isNotEmpty) {
      if (pathToDraw.actions.last is LineToAction) {
        final lastLineTo = pathToDraw.actions.last as LineToAction;
        currentEndPoint = Offset(lastLineTo.x, lastLineTo.y);
      } else if (pathToDraw.actions.last is MoveToAction) {
        final lastMoveTo = pathToDraw.actions.last as MoveToAction;
        currentEndPoint = Offset(lastMoveTo.x, lastMoveTo.y);
      }
    }

    if (_startPoint != null && pathToDraw.actions.isNotEmpty) {
      bool needsSolidClosingLine = !(currentEndPoint.dx == _startPoint!.dx &&
          currentEndPoint.dy == _startPoint!.dy);

      bool isEffectivelySingleTap =
          pathToDraw.actions.length <= (pointAddedInUp ? 2 : 1) &&
              (currentEndPoint.dx == _startPoint!.dx &&
                  currentEndPoint.dy == _startPoint!.dy);

      if (needsSolidClosingLine && !isEffectivelySingleTap) {
        final finalDashedCommand = commandFactory.createClipPathCommand(
          pathToDraw,
          paint,
          startPoint: currentEndPoint,
          endPoint: _startPoint!,
        );
        commandManager.addGraphicCommand(finalDashedCommand);
      } else {
        pathToDraw.close();
        final finalDashedCommand = commandFactory.createClipPathCommand(
          pathToDraw,
          paint,
        );
        commandManager.addGraphicCommand(finalDashedCommand);
      }
    } else {
      pathToDraw.close();
      final finalDashedCommand = commandFactory.createClipPathCommand(
        pathToDraw,
        paint,
      );
      commandManager.addGraphicCommand(finalDashedCommand);
    }
    _startPoint = null;
  }

  @override
  void onCancel() {
    commandManager.discardLastCommand();
    _startPoint = null;
  }

  @override
  void onCheckmark(Paint paint) {}

  @override
  void onPlus() {}

  @override
  void onRedo() {
    commandManager.redo();
  }

  @override
  void onUndo() {
    commandManager.undo();
  }
}
