import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeStateNotifier extends StateNotifier<ThemeModeState> {
  ThemeModeStateNotifier() : super(ThemeModeState.empty()) {
    getDefaultThemeMode();
  }

  Future<void> getDefaultThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeMode = prefs.getString('themeMode');

    if (themeMode == null) {
      return;
    }

    switch (themeMode) {
      case 'light':
        state = const ThemeModeState(themeMode: ThemeMode.light);
        break;
      case 'dark':
        state = const ThemeModeState(themeMode: ThemeMode.dark);
        break;
      case 'system':
        state = const ThemeModeState(themeMode: ThemeMode.system);
        break;
      default:
        state = const ThemeModeState(themeMode: ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = ThemeModeState(themeMode: themeMode);
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
}
