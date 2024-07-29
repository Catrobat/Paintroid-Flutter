import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';

class LightPaintroidThemeData extends PaintroidThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: CustomColors.pureWhite.toMaterialColor(),
        dividerTheme: dividerThemeData,
        floatingActionButtonTheme: fabThemeData,
        elevatedButtonTheme: buttonThemeData,
        inputDecorationTheme: inputDecorationTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: CustomColors.oceanBlue,
          foregroundColor: CustomColors.pureWhite,
        ),
        sliderTheme: SliderThemeData(
          overlayColor: CustomColors.oceanBlue.withOpacity(.2),
          activeTrackColor: CustomColors.oceanBlue,
          inactiveTrackColor: CustomColors.oceanBlue,
          thumbColor: CustomColors.oceanBlue,
          showValueIndicator: ShowValueIndicator.never,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          constraints: BoxConstraints.tightForFinite(),
          backgroundColor: CustomColors.oceanBlue,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              CustomColors.oceanBlue,
            ),
          ),
        ),
      );

  @override
  Color get primaryColor => CustomColors.oceanBlue;

  @override
  Color get scaffoldBackgroundColor => CustomColors.seaBlue;

  @override
  MaterialColor get fabBackgroundColor =>
      CustomColors.lightBlush.toMaterialColor();

  @override
  MaterialColor get fabForegroundColor =>
      CustomColors.pureWhite.toMaterialColor();

  @override
  Color get textFieldorderColor => CustomColors.jetBlack;

  @override
  TextTheme get textTheme =>
      super.textTheme.apply(bodyColor: CustomColors.deepCharcoal);

  @override
  Color get backgroundColor => CustomColors.lightBlush;

  @override
  Color get orangeColor => CustomColors.vibrantOrange;

  @override
  Color get errorColor => CustomColors.vividRed;

  @override
  Color get errorContainerColor => CustomColors.deepMaroon;

  @override
  Color get inversePrimaryColor => CustomColors.oceanTeal;

  @override
  Color get inverseSurfaceColor => CustomColors.lightGray;

  @override
  Color get onBackgroundColor => CustomColors.deepCharcoal;

  @override
  Color get onErrorColor => CustomColors.darkRed;

  @override
  Color get onErrorContainerColor => CustomColors.lightCoral;

  @override
  Color get onInverseSurfaceColor => CustomColors.darkCharcoal;

  @override
  Color get onPrimaryColor => CustomColors.deepTeal;

  @override
  Color get onPrimaryContainerColor => CustomColors.darkCyan;

  @override
  Color get onSecondaryColor => CustomColors.darkSlateGray;

  @override
  Color get onSecondaryContainerColor => CustomColors.lightBlueGray;

  @override
  Color get onSurfaceColor => CustomColors.pureWhite;

  @override
  Color get onSurfaceVariantColor => CustomColors.lightSlateGray;

  @override
  Color get onTertiaryColor => CustomColors.darkSeaGreen;

  @override
  Color get onTertiaryContainerColor => CustomColors.deepAqua;

  @override
  Color get outlineColor => CustomColors.mediumGray;

  @override
  Color get primaryContainerColor => CustomColors.darkCyan;

  @override
  Color get secondaryColor => CustomColors.softBlueGray;

  @override
  Color get secondaryContainerColor => CustomColors.mutedTeal;

  @override
  Color get shadowColor => CustomColors.jetBlack;

  @override
  Color get surfaceColor => CustomColors.seaBlue;

  @override
  Color get surfaceTintColor => CustomColors.aquaTint;

  @override
  Color get surfaceVariantColor => CustomColors.slateGray;

  @override
  Color get tertiaryColor => CustomColors.brightTurquoise;

  @override
  Color get tertiaryContainerColor => CustomColors.deepAqua;

  @override
  TextStyle get titleStyle => const TextStyle(
        color: CustomColors.pureWhite,
        fontSize: 24.0,
      );

  @override
  TextStyle get descStyle => const TextStyle(
        color: CustomColors.pureWhite,
        fontSize: 15.0,
      );

  @override
  TextStyle get hintStyle =>
      super.textTheme.bodySmall?.apply(color: onSecondaryColor) ??
      TextStyle(
        fontSize: FontSize.smallMedium,
        fontFamily: PaintroidThemeData.fontFamily,
        fontWeight: FontWeight.w100,
        color: onSecondaryColor,
      );
}
