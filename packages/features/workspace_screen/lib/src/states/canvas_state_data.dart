import 'dart:ui' as ui;

import 'package:command/command.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canvas_state_data.freezed.dart';

@immutable
@freezed
class CanvasStateData with _$CanvasStateData {
  const factory CanvasStateData({
    ui.Image? backgroundImage,
    ui.Image? cachedImage,
    required Size size,
    required CommandManager commandManager,
    required GraphicFactory graphicFactory,
  }) = _CanvasStateData;
}
