import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

const dividerThemeData = DividerThemeData(
  space: 0,
);

ElevatedButtonThemeData get buttonThemeData => ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: const StadiumBorder().materialize(),
      ),
    );

abstract class PaintroidThemeData {
  ThemeData get materialThemeData;

  double screenMargin = Spacing.mediumLarge;

  double searchBarMargin = Spacing.xSmall;

  double gridSpacing = Spacing.mediumLarge;

  double listSpacing = Spacing.mediumLarge;

  static String fontFamily = 'Avenir';

  double inputDecorationBorderRadius = Spacing.medium;

  Color get primaryColor;
  Color get onPrimaryColor;
  Color get primaryContainerColor;
  Color get onPrimaryContainerColor;
  Color get secondaryColor;
  Color get onSecondaryColor;
  Color get secondaryContainerColor;
  Color get onSecondaryContainerColor;
  Color get tertiaryColor;
  Color get onTertiaryColor;
  Color get tertiaryContainerColor;
  Color get onTertiaryContainerColor;
  Color get errorColor;
  Color get errorContainerColor;
  Color get onErrorColor;
  Color get onErrorContainerColor;
  Color get backgroundColor;
  Color get onBackgroundColor;
  Color get surfaceColor;
  Color get onSurfaceColor;
  Color get surfaceVariantColor;
  Color get onSurfaceVariantColor;
  Color get outlineColor;
  Color get onInverseSurfaceColor;
  Color get inverseSurfaceColor;
  Color get inversePrimaryColor;
  Color get shadowColor;
  Color get surfaceTintColor;

  Color get scaffoldBackgroundColor;
  Color get textFieldorderColor;
  MaterialColor get fabBackgroundColor;
  MaterialColor get fabForegroundColor;

  TextTheme get titleTheme => TextTheme(
        titleLarge: TextStyle(
          fontSize: FontSize.xLarge,
          fontFamily: PaintroidThemeData.fontFamily,
          fontWeight: FontWeight.w600,
          color: CustomColors.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: FontSize.large,
          fontFamily: PaintroidThemeData.fontFamily,
          fontWeight: FontWeight.w800,
          color: CustomColors.primary,
        ),
        titleSmall: TextStyle(
          fontSize: FontSize.smallMedium,
          fontFamily: PaintroidThemeData.fontFamily,
          fontWeight: FontWeight.w500,
          color: CustomColors.onSurface,
        ),
      );

  TextTheme get textTheme => TextTheme(
        bodyLarge: TextStyle(
          fontSize: FontSize.large,
          fontFamily: fontFamily,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontSize: FontSize.smallMedium,
          fontFamily: fontFamily,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          fontSize: FontSize.smallMedium,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w100,
        ),
      );

  FloatingActionButtonThemeData get fabThemeData =>
      FloatingActionButtonThemeData(
        backgroundColor: fabBackgroundColor.shade600,
        foregroundColor: fabForegroundColor,
      );

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: textFieldorderColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              inputDecorationBorderRadius,
            ),
          ),
        ),
      );

  NavigationBarThemeData bottomNavBarThemeData = NavigationBarThemeData(
    indicatorColor: Colors.transparent,
    backgroundColor: CustomColors.primary,
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(
        color: CustomColors.onSurface,
      ),
    ),
    iconTheme: MaterialStateProperty.all(
      const IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}

extension OutlinedBorderExtensions on OutlinedBorder {
  MaterialStateProperty<OutlinedBorder> materialize() {
    return MaterialStateProperty.all<OutlinedBorder>(this);
  }
}
