import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_mode_state.freezed.dart';

@freezed
class ThemeModeState with _$ThemeModeState {
  const factory ThemeModeState({required ThemeMode themeMode}) =
      _ThemeModeState;

  factory ThemeModeState.empty() =>
      const ThemeModeState(themeMode: ThemeMode.system);
}
