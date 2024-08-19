import 'package:flutter/material.dart';

abstract class CustomColors {
  static const oceanBlue = Color(0xFF0097A7);
  static const seaBlue = Color(0xFF0097A7);

  static const deepTeal = Color(0xFF00363D);
  static const mutedTeal = Color(0xFF334B4F);
  static const oceanTeal = Color(0xFF006874);

  static const darkCyan = Color(0xFF004F58);
  static const lightCyan = Color(0xFF97F0FF);

  static const deepAqua = Color(0xFF004F52);
  static const paleAqua = Color(0xFF6FF6FC);
  static const aquaTint = Color(0xFF4FD8EB);

  static const brightTurquoise = Color(0xFF4CD9DF);
  static const darkSeaGreen = Color(0xFF003739);

  static const vibrantOrange = Color(0xFFFFAB08);
  static const vividRed = Color(0xFFFF5454);
  static const deepMaroon = Color(0xFF93000A);
  static const darkRed = Color(0xFF690005);

  static const pureWhite = Color(0xFFFFFFFF);
  static const lightCoral = Color(0xFFFFDAD6);
  static const lightBlush = Color(0xFFFFF6F6);

  static const lightBlueGray = Color(0xFFCDE7EC);
  static const lightSlateGray = Color(0xFFBFC8CA);
  static const softBlueGray = Color(0xFFB1CBD0);
  static const mediumGray = Color(0xFF899294);
  static const lightGray = Color(0xFFE1E3E3);
  static const slateGray = Color(0xFF3F484A);
  static const darkSlateGray = Color(0xFF1C3438);

  static const darkCharcoal = Color(0xFF191C1D);
  static const deepCharcoal = Color(0xFF191C1D);
  static const jetBlack = Color(0xFF000000);

  static const transparentColor = Color(0x00000000);
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
