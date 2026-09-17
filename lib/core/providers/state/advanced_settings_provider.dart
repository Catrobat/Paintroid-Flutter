import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/advanced_settings_state_data.dart';

class AdvancedSettingsProvider extends Notifier<AdvancedSettingsStateData> {
  @override
  AdvancedSettingsStateData build() {
    return const AdvancedSettingsStateData();
  }

  void updateAntialiasing(bool isEnabled) {
    state = state.copyWith(isAntialiasingEnabled: isEnabled);
  }

  void updateSmoothing(bool isEnabled) {
    state = state.copyWith(isSmoothingEnabled: isEnabled);
  }
}

final advancedSettingsProvider = NotifierProvider<AdvancedSettingsProvider, AdvancedSettingsStateData>(
  () => AdvancedSettingsProvider(),
);