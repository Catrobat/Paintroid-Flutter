import 'package:flutter/material.dart';
import 'package:paintroid/ui/color_schemes.dart';

abstract class ThemeText {
  static TextStyle menuItem = TextStyle(
    color: lightColorScheme.onBackground,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static TextStyle largeBoldText = TextStyle(
    color: lightColorScheme.primary,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );

  static TextStyle hintTextNormal = TextStyle(
    color: lightColorScheme.onSurfaceVariant,
    fontWeight: FontWeight.w100,
    fontSize: 14,
  );
}
