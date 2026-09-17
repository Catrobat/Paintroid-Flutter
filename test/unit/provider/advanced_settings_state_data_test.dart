import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/providers/state/advanced_settings_state_data.dart';

void main() {
  group('AdvancedSettingsStateData', () {
    test('initial state should have antialiasing and smoothing disabled', () {
      
      const state = AdvancedSettingsStateData();

      expect(state.isAntialiasingEnabled, isTrue);
      expect(state.isSmoothingEnabled, isTrue);
    });
  });
}
