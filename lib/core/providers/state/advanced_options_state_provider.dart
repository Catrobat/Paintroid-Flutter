import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:paintroid/core/providers/state/advanced_options_state_data.dart';

part 'advanced_options_state_provider.g.dart';

const _kAntialiasingPrefsKey = 'isAntialiasingEnabled';
const _kSmoothingPrefsKey = 'isSmoothingEnabled';

@Riverpod(keepAlive: true)
class AdvancedOptionsState extends _$AdvancedOptionsState {
  @override
  AdvancedOptionsStateData build() {
    _loadFromPrefs();
    return const AdvancedOptionsStateData();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isAntialiasingEnabled =
        prefs.getBool(_kAntialiasingPrefsKey) ?? false;
    final isSmoothingEnabled = prefs.getBool(_kSmoothingPrefsKey) ?? false;
    
    state = state.copyWith(
      isAntialiasingEnabled: isAntialiasingEnabled,
      isSmoothingEnabled: isSmoothingEnabled,
    );
  }

  Future<void> toggleAntialiasing() async {
    final newValue = !state.isAntialiasingEnabled;
    state = state.copyWith(isAntialiasingEnabled: newValue);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAntialiasingPrefsKey, newValue);
  }

  Future<void> toggleSmoothing() async {
    final newValue = !state.isSmoothingEnabled;
    state = state.copyWith(isSmoothingEnabled: newValue);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSmoothingPrefsKey, newValue);
  }
}
