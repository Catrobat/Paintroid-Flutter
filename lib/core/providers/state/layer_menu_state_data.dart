import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/providers/state/layer_state_data.dart';

part 'layer_menu_state_data.freezed.dart';

@immutable
@freezed
class LayerMenuStateData with _$LayerMenuStateData {
  const factory LayerMenuStateData({
    required bool isVisible,
    required List<LayerStateData> layer,
  }) = _LayerMenuStateData;
}
