import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/color_changed_command.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/core/tools/tool.dart';

class PipetteTool extends Tool {
  final PaintProvider paintProvider;
  final CanvasStateProvider canvasStateProvider;
  Color? _initialColor;

  PipetteTool({
    required super.commandFactory,
    required super.commandManager,
    required super.type,
    required this.paintProvider,
    required this.canvasStateProvider,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    _initialColor = paint.color;
    _pickColor(point);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    _pickColor(point);
  }

  @override
  void onUp(Offset point, Paint paint) {
    _pickColor(point, isFinal: true, originalPaint: paint);
  }

  @override
  void onCancel() {
    if (_initialColor != null) {
      paintProvider.updateColor(_initialColor!);
    }
    _initialColor = null;
  }

  @override
  void onUndo() {
    if (commandManager.undoStack.isEmpty) return;
    final lastCommand = commandManager.undoStack.last;
    if (lastCommand is ColorChangedCommand) {
      paintProvider.updateColor(lastCommand.oldColor);
    }
    commandManager.undo();
  }

  @override
  void onRedo() {
    if (commandManager.redoStack.isEmpty) return;
    final nextCommand = commandManager.redoStack.last;
    if (nextCommand is ColorChangedCommand) {
      paintProvider.updateColor(nextCommand.newColor);
    }
    commandManager.redo();
  }

  @override
  void onCheckmark(Paint paint) {}

  @override
  void onPlus() {}

  Future<void> _pickColor(Offset point,
      {bool isFinal = false, Paint? originalPaint}) async {
    final image = canvasStateProvider.currentState.cachedImage;
    if (image == null) return;

    if (point.dx < 0 ||
        point.dy < 0 ||
        point.dx >= image.width ||
        point.dy >= image.height) {
      if (isFinal) {
        _initialColor = null;
      }
      return;
    }

    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      if (isFinal) {
        _initialColor = null;
      }
      return;
    }

    final int x = point.dx.toInt();
    final int y = point.dy.toInt();
    final int offset = (y * image.width + x) * 4;

    if (offset + 3 >= byteData.lengthInBytes) {
      if (isFinal) {
        _initialColor = null;
      }
      return;
    }

    final int r = byteData.getUint8(offset);
    final int g = byteData.getUint8(offset + 1);
    final int b = byteData.getUint8(offset + 2);
    final int a = byteData.getUint8(offset + 3);

    final pickedColor = Color.fromARGB(a, r, g, b);
    paintProvider.updateColor(pickedColor);

    if (isFinal) {
      if (_initialColor != null && _initialColor != pickedColor) {
        final command = commandFactory.createColorChangedCommand(
          _initialColor!,
          pickedColor,
          originalPaint!,
        );
        commandManager.addGraphicCommand(command);
      }
      _initialColor = null;
    }
  }
}
