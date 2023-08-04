import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/command/src/command_manager.dart';
import 'package:paintroid/core/graphic_factory.dart';

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
