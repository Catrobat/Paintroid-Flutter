import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';

void main() {
  group('AdvancedSettingsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('updateAntialiasing should update the state correctly', () {

      final notifier = container.read(advancedSettingsProvider.notifier);
      notifier.updateAntialiasing(true);

      final state = container.read(advancedSettingsProvider);
      expect(state.isAntialiasingEnabled, isTrue);
    });

    test('updateSmoothing should update the state correctly', () {

      final notifier = container.read(advancedSettingsProvider.notifier);
      notifier.updateSmoothing(true);

      final state = container.read(advancedSettingsProvider);
      expect(state.isSmoothingEnabled, isTrue);
    });
  });
}