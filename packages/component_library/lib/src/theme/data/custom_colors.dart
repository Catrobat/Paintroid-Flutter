import 'package:flutter/material.dart';

abstract class CustomColors {
  static const primary = Color(0xFF0097A7);
  static const onPrimary = Color(0xFF00363D);
  static const primaryContainer = Color(0xFF004F58);
  static const onPrimaryContainer = Color(0xFF97F0FF);
  static const secondary = Color(0xFFB1CBD0);
  static const onSecondary = Color(0xFF1C3438);
  static const secondaryContainer = Color(0xFF334B4F);
  static const onSecondaryContainer = Color(0xFFCDE7EC);
  static const tertiary = Color(0xFF4CD9DF);
  static const onTertiary = Color(0xFF003739);
  static const tertiaryContainer = Color(0xFF004F52);
  static const onTertiaryContainer = Color(0xFF6FF6FC);
  static const error = Color(0xFFFF5454);
  static const errorContainer = Color(0xFF93000A);
  static const onError = Color(0xFF690005);
  static const onErrorContainer = Color(0xFFFFDAD6);
  static const background = Color(0xFFFFF6F6);
  static const onBackground = Color(0xFF191C1D);
  static const surface = Color(0xFF0097A7);
  static const onSurface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFF3F484A);
  static const onSurfaceVariant = Color(0xFFBFC8CA);
  static const outline = Color(0xFF899294);
  static const onInverseSurface = Color(0xFF191C1D);
  static const inverseSurface = Color(0xFFE1E3E3);
  static const inversePrimary = Color(0xFF006874);
  static const shadow = Color(0xFF000000);
  static const surfaceTint = Color(0xFF4FD8EB);
}

extension ToMaterialColor on Color {
  Map<int, Color> _toSwatch() => {
        50: withOpacity(0.1),
        100: withOpacity(0.2),
        200: withOpacity(0.3),
        300: withOpacity(0.4),
        400: withOpacity(0.5),
        500: withOpacity(0.6),
        600: withOpacity(0.7),
        700: withOpacity(0.8),
        800: withOpacity(0.9),
        900: this,
      };

  MaterialColor toMaterialColor() => MaterialColor(
        value,
        _toSwatch(),
      );
}
