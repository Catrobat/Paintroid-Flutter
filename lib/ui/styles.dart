import 'package:flutter/material.dart';
import 'package:paintroid/ui/color_schemes.dart';

abstract class ThemeText {
  static TextStyle menuItem = TextStyle(
    color: lightColorScheme.onBackground,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
}
