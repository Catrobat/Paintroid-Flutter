import 'package:freezed_annotation/freezed_annotation.dart';

part 'advanced_options_state_data.freezed.dart';

@freezed
class AdvancedOptionsStateData with _$AdvancedOptionsStateData {
  const factory AdvancedOptionsStateData({
    @Default(false) bool isAntialiasingEnabled,
    @Default(false) bool isSmoothingEnabled,
  }) = _AdvancedOptionsStateData;
}
