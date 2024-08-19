import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';


class OnboardingPageBottomNavigationBar extends StatefulWidget {
  final List<VoidCallback> onPressedFunctions;
  final List<BottomNavigationBarItem> barItems;

  const OnboardingPageBottomNavigationBar(
      {super.key, required this.onPressedFunctions, required this.barItems});

  @override
  State<OnboardingPageBottomNavigationBar> createState() =>
      _OnboardingPageBottomNavigationBarState();
}

class _OnboardingPageBottomNavigationBarState
    extends State<OnboardingPageBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      backgroundColor: PaintroidTheme.of(context).surfaceColor,
      selectedItemColor: PaintroidTheme.of(context).onSurfaceColor,
      unselectedItemColor: PaintroidTheme.of(context).onSurfaceColor,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (value) {
        widget.onPressedFunctions[value]();
        setState(() => _currentIndex = value);
      },
      items: widget.barItems,
    );
  }
}
