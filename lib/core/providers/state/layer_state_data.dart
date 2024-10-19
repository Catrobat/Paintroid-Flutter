import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layer_state_data.freezed.dart';

@immutable
@freezed
class LayerStateData with _$LayerStateData {
  const factory LayerStateData({
    required ValueKey key,
    required bool isSelected,
    required bool isVisible,
    required double opacity,
    ui.Image? image,
  }) = _LayerStateData;
}
