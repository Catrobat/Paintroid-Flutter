// Dart imports:
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:command/command.dart';
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
