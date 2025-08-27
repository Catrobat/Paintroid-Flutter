import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/tools/clipping_tool_state_provider.dart';

class ClippingTool extends Tool {
  final GraphicFactory graphicFactory;
  final ClippingToolState clippingToolState;
  final CanvasStateProvider canvasStateProvider;

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
    required this.canvasStateProvider,
    super.type = ToolType.CLIPPING,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = true,
  });

  @override
  void onDown(Offset point, Paint paint) {
    bool requiresRefresh = false;
    if (clippingToolState.hasActiveClipPath) {
      if (_activePreviewCommand != null) {
        commandManager.removeCommand(_activePreviewCommand!);
        _activePreviewCommand = null;
        requiresRefresh = true;
      }
      clippingToolState.clearClipPath();
    }

    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
      requiresRefresh = true;
    }

    if (requiresRefresh) {
      canvasStateProvider.resetCanvasWithExistingCommands();
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
    bool requiresRefresh = false;
    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
      requiresRefresh = true;
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

    if (requiresRefresh) {
      canvasStateProvider.resetCanvasWithExistingCommands();
    }
    canvasStateProvider.updateCachedImage();
  }

  @override
  void onCancel() {
    bool requiresRefresh = false;
    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
      requiresRefresh = true;
    }

    if (clippingToolState.hasActiveClipPath) {
      if (_activePreviewCommand != null) {
        commandManager.removeCommand(_activePreviewCommand!);
        _activePreviewCommand = null;
        requiresRefresh = true;
      }
      clippingToolState.clearClipPath();
    }

    if (requiresRefresh) {
      canvasStateProvider.resetCanvasWithExistingCommands();
    }
    _startPoint = null;
  }

  @override
  void onCheckmark(Paint paint) {
    bool requiresRefresh = false;
    if (clippingToolState.hasActiveClipPath) {
      if (_activePreviewCommand != null) {
        commandManager.removeCommand(_activePreviewCommand!);
        _activePreviewCommand = null;
        requiresRefresh = true;
      }
      clippingToolState.clearClipPath();
    }

    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
      requiresRefresh = true;
    }

    if (pathToDraw.actions.isNotEmpty) {
      pathToDraw.close();

      final cropCommand =
          commandFactory.createClipAreaCommand(pathToDraw, paint);
      commandManager.addGraphicCommand(cropCommand);
      requiresRefresh = true;
    }

    if (requiresRefresh) {
      canvasStateProvider.resetCanvasWithExistingCommands();
    }
    _startPoint = null;
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
