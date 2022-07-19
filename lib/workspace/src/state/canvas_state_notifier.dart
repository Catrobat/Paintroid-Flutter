import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';

part 'canvas_state.dart';

class CanvasStateNotifier extends StateNotifier<CanvasState> {
  CanvasStateNotifier(super.state, this._commandManager, this._graphicFactory);

  final CommandManager _commandManager;
  final GraphicFactory _graphicFactory;

  void updateCanvasSize(Size newSize) => state = state.copyWith(size: newSize);

  void updateLastCompiledImage() async {
    final recorder = _graphicFactory.createPictureRecorder();
    final canvas = _graphicFactory.createCanvasWithRecorder(recorder);
    final paint = _graphicFactory.createPaint();
    if (state.lastCompiledImage != null) {
      canvas.drawImage(state.lastCompiledImage!, Offset.zero, paint);
    }
    _commandManager.executeLastCommand(canvas);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
        state.size.width.toInt(), state.size.height.toInt());
    state = state.copyWith(lastCompiledImage: image);
  }
}
