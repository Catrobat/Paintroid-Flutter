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
  PathWithActionHistory? pathToDraw;
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
        commandFactory.createClipPathCommand(pathToDraw!, paint);
    commandManager.addGraphicCommand(newLiveDrawingCommand);
    _liveDrawingCommand = newLiveDrawingCommand;
  }

  @override
  void onDrag(Offset point, Paint paint) {
    pathToDraw?.lineTo(point.dx, point.dy);
  }

  @override
  void onUp(Offset point, Paint paint) {
    final path = pathToDraw;
    if (path == null) return;

    bool requiresRefresh = false;
    if (_liveDrawingCommand != null) {
      commandManager.removeCommand(_liveDrawingCommand!);
      _liveDrawingCommand = null;
      requiresRefresh = true;
    }

    bool pointAddedInUp = false;
    if (path.actions.isNotEmpty) {
      final lastAction = path.actions.last;
      bool isSameAsLastPoint = false;

      if (lastAction is LineToAction) {
        isSameAsLastPoint =
            (lastAction.x == point.dx && lastAction.y == point.dy);
      } else if (lastAction is MoveToAction && path.actions.length == 1) {
        isSameAsLastPoint =
            (lastAction.x == point.dx && lastAction.y == point.dy);
      }

      if (!isSameAsLastPoint) {
        path.lineTo(point.dx, point.dy);
        pointAddedInUp = true;
      }
    } else {
      path.moveTo(point.dx, point.dy);
      path.lineTo(point.dx, point.dy);
      pointAddedInUp = true;
    }

    Offset currentEndPoint = point;
    if (path.actions.isNotEmpty) {
      if (path.actions.last is LineToAction) {
        final lastLineTo = path.actions.last as LineToAction;
        currentEndPoint = Offset(lastLineTo.x, lastLineTo.y);
      } else if (path.actions.last is MoveToAction) {
        final lastMoveTo = path.actions.last as MoveToAction;
        currentEndPoint = Offset(lastMoveTo.x, lastMoveTo.y);
      }
    }

    GraphicCommand newPreviewCommand;
    if (_startPoint != null && path.actions.isNotEmpty) {
      bool needsSolidClosingLine = !(currentEndPoint.dx == _startPoint!.dx &&
          currentEndPoint.dy == _startPoint!.dy);

      bool isEffectivelySingleTap =
          path.actions.length <= (pointAddedInUp ? 2 : 1) &&
              (currentEndPoint.dx == _startPoint!.dx &&
                  currentEndPoint.dy == _startPoint!.dy);

      if (needsSolidClosingLine && !isEffectivelySingleTap) {
        newPreviewCommand = commandFactory.createClipPathCommand(
          path,
          paint,
          startPoint: currentEndPoint,
          endPoint: _startPoint!,
        );
      } else {
        path.close();
        newPreviewCommand = commandFactory.createClipPathCommand(
          path,
          paint,
        );
      }
    } else {
      path.close();
      newPreviewCommand = commandFactory.createClipPathCommand(
        path,
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

    final path = pathToDraw;
    if (path != null && path.actions.isNotEmpty) {
      path.close();

      final cropCommand =
          commandFactory.createClipAreaCommand(path, paint);
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
