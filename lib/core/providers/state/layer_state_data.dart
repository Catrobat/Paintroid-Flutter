import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layer_state_data.freezed.dart';

@immutable
@freezed
class LayerStateData with _$LayerStateData {
  const factory LayerStateData({
    required ValueKey key,
    required bool isSelected,
  }) = _LayerStateData;
}
