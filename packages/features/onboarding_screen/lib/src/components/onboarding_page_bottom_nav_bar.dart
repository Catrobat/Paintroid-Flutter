// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:component_library/component_library.dart';

class OnboardingPageBottomNavigationBar extends StatefulWidget {
  final List<VoidCallback> onPressedFunctions;
  final List<BottomNavigationBarItem> barItems;

  const OnboardingPageBottomNavigationBar(
      {Key? key, required this.onPressedFunctions, required this.barItems})
      : super(key: key);

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
      backgroundColor: lightColorScheme.surface,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
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
