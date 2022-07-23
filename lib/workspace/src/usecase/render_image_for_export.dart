import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/workspace/workspace.dart';

class RenderImageForExport {
  final Ref _ref;
  final GraphicFactory _graphicFactory;
  final CommandManager _commandManager;

  static final provider = Provider(
    (ref) => RenderImageForExport(
      ref,
      ref.watch(GraphicFactory.provider),
      ref.watch(CommandManager.provider),
    ),
  );

  const RenderImageForExport(
      this._ref, this._graphicFactory, this._commandManager);

  Future<Image> call() async {
    final recorder = _graphicFactory.createPictureRecorder();
    final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
    final canvasSize = _ref.read(CanvasState.provider).size;
    final workspaceState = _ref.read(WorkspaceState.provider);
    final exportSize = workspaceState.exportSize;
    final loadedImage = workspaceState.loadedImage;
    final scaledRect = Rect.fromLTWH(0, 0, exportSize.width, exportSize.height);
    if (loadedImage != null) {
      paintImage(
        canvas: canvas,
        rect: scaledRect,
        image: loadedImage,
        fit: BoxFit.fill,
      );
    }
    canvas.scale(exportSize.width / canvasSize.width);
    canvas.clipRect(scaledRect);
    _commandManager.executeAllCommands(canvas);
    final picture = recorder.endRecording();
    return await picture.toImage(
        exportSize.width.toInt(), exportSize.height.toInt());
  }
}
