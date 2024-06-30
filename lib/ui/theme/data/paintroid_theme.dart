import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';


class PaintroidTheme extends InheritedWidget {
  const PaintroidTheme({
    required super.child,
    required this.lightTheme,
    required this.darkTheme,
    super.key,
  });

  final PaintroidThemeData lightTheme;
  final PaintroidThemeData darkTheme;

  @override
  bool updateShouldNotify(
    PaintroidTheme oldWidget,
  ) =>
      oldWidget.lightTheme != lightTheme || oldWidget.darkTheme != darkTheme;

  static PaintroidThemeData of(BuildContext context) {
    final PaintroidTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<PaintroidTheme>();
    assert(inheritedTheme != null, 'No PaintroidTheme found in context');
    final currentBrightness = Theme.of(context).brightness;
    return currentBrightness == Brightness.dark
        ? inheritedTheme!.darkTheme
        : inheritedTheme!.lightTheme;
  }
}
