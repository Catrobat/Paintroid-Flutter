import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/command/src/command_manager_provider.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/graphic_factory_provider.dart';
import 'package:paintroid/workspace/src/state/canvas/canvas_state_provider.dart';

class RenderImageForExport {
  final Ref _ref;
  final GraphicFactory _graphicFactory;
  final CommandManager _commandManager;

  static final provider = Provider(
    (ref) => RenderImageForExport(
      ref,
      ref.watch(graphicFactoryProvider),
      ref.watch(commandManagerProvider),
    ),
  );

  const RenderImageForExport(
      this._ref, this._graphicFactory, this._commandManager);

  Future<Image> call({bool keepTransparency = true}) async {
    final backgroundRecorder = _graphicFactory.createPictureRecorder();
    final backgroundCanvas =
        _graphicFactory.createCanvasWithRecorder(backgroundRecorder);

    final canvasState = _ref.read(canvasStateProvider);
    final exportSize = canvasState.size;

    if (!keepTransparency) {
      final paint = _graphicFactory.createPaint();
      backgroundCanvas.drawPaint(paint..color = const Color(0xFFFFFFFF));
    }

    final scaledRect = Rect.fromLTWH(0, 0, exportSize.width, exportSize.height);
    if (canvasState.backgroundImage != null) {
      paintImage(
        canvas: backgroundCanvas,
        rect: scaledRect,
        image: canvasState.backgroundImage!,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      );
    }

    final foregroundRecorder = _graphicFactory.createPictureRecorder();
    final foregroundCanvas =
        _graphicFactory.createCanvasWithRecorder(foregroundRecorder);

    foregroundCanvas.clipRect(scaledRect, doAntiAlias: false);
    _commandManager.executeAllCommands(foregroundCanvas);

    final combinedRecorder = _graphicFactory.createPictureRecorder();
    final combinedCanvas =
        _graphicFactory.createCanvasWithRecorder(combinedRecorder);

    final backgroundImage = await backgroundRecorder
        .endRecording()
        .toImage(exportSize.width.toInt(), exportSize.height.toInt());

    combinedCanvas.drawImage(backgroundImage, const Offset(0, 0), Paint());

    final foregroundImage = await foregroundRecorder
        .endRecording()
        .toImage(exportSize.width.toInt(), exportSize.height.toInt());

    combinedCanvas.drawImage(foregroundImage, const Offset(0, 0), Paint());

    return await combinedRecorder
        .endRecording()
        .toImage(exportSize.width.toInt(), exportSize.height.toInt());
  }
}
