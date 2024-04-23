// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:component_library/component_library.dart';

class PaintroidTheme extends InheritedWidget {
  const PaintroidTheme({
    required Widget child,
    required this.lightTheme,
    required this.darkTheme,
    Key? key,
  }) : super(
          key: key,
          child: child,
        );

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
