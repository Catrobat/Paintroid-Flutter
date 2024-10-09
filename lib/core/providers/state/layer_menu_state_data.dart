import 'package:freezed_annotation/freezed_annotation.dart';

part 'layer_menu_state_data.freezed.dart';

@immutable
@freezed
class LayerMenuStateData with _$LayerMenuStateData {
  const factory LayerMenuStateData({
    required bool isVisible,
  }) = _LayerMenuStateData;
}
