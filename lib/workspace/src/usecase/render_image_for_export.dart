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

  Future<Image> call({bool keepTransparency = true}) async {
    final recorder = _graphicFactory.createPictureRecorder();
    final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
    if (!keepTransparency) {
      final paint = _graphicFactory.createPaint();
      canvas.drawPaint(paint..color = const Color(0xFFFFFFFF));
    }
    final canvasState = _ref.read(CanvasState.provider);
    final exportSize = canvasState.size;
    final backgroundImage = canvasState.backgroundImage;
    final scaledRect = Rect.fromLTWH(0, 0, exportSize.width, exportSize.height);
    if (backgroundImage != null) {
      paintImage(
        canvas: canvas,
        rect: scaledRect,
        image: backgroundImage,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      );
    }
    canvas.clipRect(scaledRect, doAntiAlias: false);
    _commandManager.executeAllCommands(canvas);
    final picture = recorder.endRecording();
    return await picture.toImage(
        exportSize.width.toInt(), exportSize.height.toInt());
  }
}
