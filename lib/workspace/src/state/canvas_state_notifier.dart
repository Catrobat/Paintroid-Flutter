import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/service/device_service.dart';

part 'canvas_state.dart';

class CanvasStateNotifier extends StateNotifier<CanvasState> {
  CanvasStateNotifier(super.state, this._commandManager, this._graphicFactory);

  final CommandManager _commandManager;
  final GraphicFactory _graphicFactory;

  void setBackgroundImage(Image image) => state = state.copyWith(
        backgroundImage: Option.some(image),
        size: Size(image.width.toDouble(), image.height.toDouble()),
      );

  void clearBackgroundImageAndResetDimensions() => state = state.copyWith(
        backgroundImage: const Option.none(),
        size: CanvasState.initial.size,
      );

  Future<void> updateCachedImage() async {
    final recorder = _graphicFactory.createPictureRecorder();
    final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
    final size = state.size;
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    if (state.cachedImage != null) {
      paintImage(
          canvas: canvas,
          rect: bounds,
          image: state.cachedImage!,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.none);
    }
    canvas.clipRect(bounds);
    _commandManager.executeLastCommand(canvas);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    state = state.copyWith(cachedImage: Option.some(img));
  }

  Future<void> resetCanvasWithNewCommands(Iterable<Command> commands) async {
    _commandManager.clearHistory(newCommands: commands);
    if (commands.isEmpty) {
      state = state.copyWith(cachedImage: const Option.none());
    } else {
      final recorder = _graphicFactory.createPictureRecorder();
      final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
      final size = state.size;
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
      _commandManager.executeAllCommands(canvas);
      final picture = recorder.endRecording();
      final img =
          await picture.toImage(size.width.toInt(), size.height.toInt());
      state = state.copyWith(cachedImage: Option.some(img));
    }
  }
}
