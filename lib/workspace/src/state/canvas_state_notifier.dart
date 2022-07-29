import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifier, StateNotifierProvider;
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';

part 'canvas_state.dart';

class CanvasStateNotifier extends StateNotifier<CanvasState> {
  CanvasStateNotifier(super.state, this._commandManager, this._graphicFactory);

  final CommandManager _commandManager;
  final GraphicFactory _graphicFactory;

  final _imageScale = window.devicePixelRatio;

  void updateCanvasSize(Size newSize) => state = state.copyWith(size: newSize);

  void renderImageWithLastCommand() async {
    final recorder = _graphicFactory.createPictureRecorder();
    final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
    final size = state.size * _imageScale;
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    if (state.lastRenderedImage != null) {
      paintImage(
          canvas: canvas,
          rect: bounds,
          image: state.lastRenderedImage!,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.none);
    }
    canvas.scale(_imageScale);
    canvas.clipRect(bounds);
    _commandManager.executeLastCommand(canvas);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    state = state.copyWith(lastRenderedImage: Option.some(img));
  }

  void clearCanvas() {
    _commandManager.resetHistory();
    state = state.copyWith(lastRenderedImage: Option.none());
  }

  void renderAndReplaceImageWithCommands(Iterable<Command> commands) async {
    final recorder = _graphicFactory.createPictureRecorder();
    final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
    final size = state.size * _imageScale;
    canvas.scale(_imageScale);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    _commandManager.resetHistory(newCommands: commands);
    _commandManager.executeAllCommands(canvas);
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    state = state.copyWith(lastRenderedImage: Option.some(image));
  }
}
