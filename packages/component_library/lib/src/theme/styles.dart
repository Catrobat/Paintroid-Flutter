import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

abstract class TextThemes {
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

abstract class WidgetThemes {
  static NavigationBarThemeData bottomNavBarThemeData = NavigationBarThemeData(
    indicatorColor: Colors.transparent,
    labelTextStyle: MaterialStateProperty.all(
      TextStyle(
        color: lightColorScheme.onSurface,
      ),
    ),
  );
}
