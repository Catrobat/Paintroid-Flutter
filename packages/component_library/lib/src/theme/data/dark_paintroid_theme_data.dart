// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:component_library/component_library.dart';

class DarkPaintroidThemeData extends PaintroidThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: CustomColors.onSurface.toMaterialColor(),
        dividerTheme: dividerThemeData,
        floatingActionButtonTheme: fabThemeData,
        elevatedButtonTheme: buttonThemeData,
        inputDecorationTheme: inputDecorationTheme,
      );

  @override
  Color get primaryColor => CustomColors.primary;

  @override
  Color get scaffoldBackgroundColor => CustomColors.surface;

  @override
  MaterialColor get fabBackgroundColor =>
      CustomColors.background.toMaterialColor();

  @override
  MaterialColor get fabForegroundColor =>
      CustomColors.onSurface.toMaterialColor();

  @override
  Color get textFieldorderColor => CustomColors.shadow;

  @override
  TextTheme get textTheme =>
      super.textTheme.apply(bodyColor: CustomColors.onBackground);

  @override
  Color get backgroundColor => CustomColors.background;

  @override
  Color get orangeColor => CustomColors.orange;

  @override
  Color get errorColor => CustomColors.error;

  @override
  Color get errorContainerColor => CustomColors.errorContainer;

  @override
  Color get inversePrimaryColor => CustomColors.inversePrimary;

  @override
  Color get inverseSurfaceColor => CustomColors.inverseSurface;

  @override
  Color get onBackgroundColor => CustomColors.onBackground;

  @override
  Color get onErrorColor => CustomColors.onError;

  @override
  Color get onErrorContainerColor => CustomColors.onErrorContainer;

  @override
  Color get onInverseSurfaceColor => CustomColors.onInverseSurface;

  @override
  Color get onPrimaryColor => CustomColors.onPrimary;

  @override
  Color get onPrimaryContainerColor => CustomColors.onPrimaryContainer;

  @override
  Color get onSecondaryColor => CustomColors.onSecondary;

  @override
  Color get onSecondaryContainerColor => CustomColors.onSecondaryContainer;

  @override
  Color get onSurfaceColor => CustomColors.onSurface;

  @override
  Color get onSurfaceVariantColor => CustomColors.onSurfaceVariant;

  @override
  Color get onTertiaryColor => CustomColors.onTertiary;

  @override
  Color get onTertiaryContainerColor => CustomColors.onTertiaryContainer;

  @override
  Color get outlineColor => CustomColors.outline;

  @override
  Color get primaryContainerColor => CustomColors.primaryContainer;

  @override
  Color get secondaryColor => CustomColors.secondary;

  @override
  Color get secondaryContainerColor => CustomColors.secondaryContainer;

  @override
  Color get shadowColor => CustomColors.shadow;

  @override
  Color get surfaceColor => CustomColors.surface;

  @override
  Color get surfaceTintColor => CustomColors.surfaceTint;

  @override
  Color get surfaceVariantColor => CustomColors.surfaceVariant;

  @override
  Color get tertiaryColor => CustomColors.tertiary;

  @override
  Color get tertiaryContainerColor => CustomColors.tertiaryContainer;
}
