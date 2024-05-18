// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_state_provider.g.dart';

@riverpod
class ThemeModeState extends _$ThemeModeState {
  Future<void> getDefaultThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeMode = prefs.getString('themeMode');

    if (themeMode == null) {
      return;
    }

    switch (themeMode) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      case 'system':
        state = ThemeMode.system;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = ThemeMode.system;
    switch (themeMode) {
      case ThemeMode.light:
        await prefs.setString('themeMode', 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString('themeMode', 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString('themeMode', 'system');
        break;
      default:
    }
  }

  @override
  ThemeMode build() {
    return ThemeMode.system;
  }
}
