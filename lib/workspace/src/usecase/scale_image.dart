import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';

class ScaleImage {
  final GraphicFactory graphicFactory;
  final CommandManager commandManager;

  static final provider = Provider(
    (ref) => ScaleImage(
      ref.watch(GraphicFactory.provider),
      ref.watch(CommandManager.provider),
    ),
  );

  const ScaleImage(this.graphicFactory, this.commandManager);

  Future<Image> call(
      Size originalSize, Size scaledSize, Image? backgroundImage) async {
    final recorder = graphicFactory.createPictureRecorder();
    final canvas = graphicFactory.createCanvasWithRecorder(recorder);
    final scaledRect = Rect.fromLTWH(0, 0, scaledSize.width, scaledSize.height);
    if (backgroundImage != null) {
      paintImage(
        canvas: canvas,
        rect: scaledRect,
        image: backgroundImage,
        fit: BoxFit.fill,
      );
    }
    canvas.scale(scaledSize.width / originalSize.width);
    canvas.clipRect(scaledRect);
    commandManager.executeAllCommands(canvas);
    final picture = recorder.endRecording();
    return await picture.toImage(
        scaledSize.width.toInt(), scaledSize.height.toInt());
  }
}
