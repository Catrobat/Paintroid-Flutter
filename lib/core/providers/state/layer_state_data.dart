import 'package:freezed_annotation/freezed_annotation.dart';

part 'layer_state_data.freezed.dart';

@immutable
@freezed
class LayerStateData with _$LayerStateData {
  const factory LayerStateData({
    required int id,
    required bool isSelected,
  }) = _LayerStateData;
}
