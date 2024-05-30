// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/painting.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';

class RenderImageForExport {
  final Ref _ref;
  final GraphicFactory _graphicFactory;
  final ICommandManager _commandManager;

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
