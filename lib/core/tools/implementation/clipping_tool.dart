import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/clipping_tool_state_provider.dart';

class ClippingTool extends Tool {
  final GraphicFactory graphicFactory;
  final ClippingToolState clippingToolState;

  @visibleForTesting
  late PathWithActionHistory pathToDraw;
  Offset? _startPoint;
  GraphicCommand? _activePreviewCommand;
  GraphicCommand? _liveDrawingCommand;

  ClippingTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required this.clippingToolState,
    super.type = ToolType.CLIPPING,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  @override
  void onDown(Offset point, Paint paint) {
    if (clippingToolState.hasActiveClipPath) {
      if (_activePreviewCommand != null) {
        commandManager.removeCommand(_activePreviewCommand!);
        _activePreviewCommand = null;
      }
      clippingToolState.clearClipPath();
    }

    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
    }

    _startPoint = point;
    pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(point.dx, point.dy);

    final newLiveDrawingCommand =
        commandFactory.createClipPathCommand(pathToDraw, paint);
    commandManager.addGraphicCommand(newLiveDrawingCommand);
    _liveDrawingCommand = newLiveDrawingCommand;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    pathToDraw.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset point, Paint paint) {
    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
    }

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

    GraphicCommand newPreviewCommand;
    if (_startPoint != null && pathToDraw.actions.isNotEmpty) {
      bool needsSolidClosingLine = !(currentEndPoint.dx == _startPoint!.dx &&
          currentEndPoint.dy == _startPoint!.dy);

      bool isEffectivelySingleTap =
          pathToDraw.actions.length <= (pointAddedInUp ? 2 : 1) &&
              (currentEndPoint.dx == _startPoint!.dx &&
                  currentEndPoint.dy == _startPoint!.dy);

      if (needsSolidClosingLine && !isEffectivelySingleTap) {
        newPreviewCommand = commandFactory.createClipPathCommand(
          pathToDraw,
          paint,
          startPoint: currentEndPoint,
          endPoint: _startPoint!,
        );
      } else {
        pathToDraw.close();
        newPreviewCommand = commandFactory.createClipPathCommand(
          pathToDraw,
          paint,
        );
      }
    } else {
      pathToDraw.close();
      newPreviewCommand = commandFactory.createClipPathCommand(
        pathToDraw,
        paint,
      );
    }
    commandManager.addGraphicCommand(newPreviewCommand);
    _activePreviewCommand = newPreviewCommand;
    clippingToolState.setHasActiveClipPath(true);
    _startPoint = null;
  }

  @override
  void onCancel() {
    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
    }

    if (clippingToolState.hasActiveClipPath) {
      if (_activePreviewCommand != null) {
        commandManager.removeCommand(_activePreviewCommand!);
        _activePreviewCommand = null;
      }
      clippingToolState.clearClipPath();
    }
    _startPoint = null;
  }

  @override
  void onCheckmark(Paint paint) {
    if (clippingToolState.hasActiveClipPath) {
      if (_activePreviewCommand != null) {
        commandManager.removeCommand(_activePreviewCommand!);
        _activePreviewCommand = null;
      }
      clippingToolState.clearClipPath();
    }

    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
    }

    if (pathToDraw.actions.isNotEmpty) {
      pathToDraw.close();

      final cropCommand =
          commandFactory.createClipAreaCommand(pathToDraw, paint);
      commandManager.addGraphicCommand(cropCommand);
    }
    _startPoint = null;
  }

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
