// Dart imports:
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';

part 'canvas_state_data.freezed.dart';

@immutable
@freezed
class CanvasStateData with _$CanvasStateData {
  const factory CanvasStateData({
    ui.Image? backgroundImage,
    ui.Image? cachedImage,
    required Size size,
    required ICommandManager commandManager,
    required GraphicFactory graphicFactory,
  }) = _CanvasStateData;
}
