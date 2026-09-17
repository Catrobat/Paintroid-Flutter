import 'package:freezed_annotation/freezed_annotation.dart';

part 'advanced_settings_state_data.freezed.dart';

@freezed
class AdvancedSettingsStateData with _$AdvancedSettingsStateData {
  const factory AdvancedSettingsStateData({
    @Default(true) bool isAntialiasingEnabled,
    @Default(true) bool isSmoothingEnabled,
  }) = _AdvancedSettingsStateData;
}