import 'package:flutter/material.dart';

import 'color_schemes.dart';
import 'onboarding_page_bottom_nav_bar.dart';

class BottomNavigationBarContainer extends StatelessWidget {
  final List<BottomNavigationBarItem> navBarItems;
  final List<VoidCallback> onPressedFunctions;

  const BottomNavigationBarContainer({
    Key? key,
    required this.navBarItems,
    required this.onPressedFunctions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: lightColorScheme.surface,
      child: OnboardingPageBottomNavigationBar(
        onPressedFunctions: onPressedFunctions,
        barItems: navBarItems,
      ),
    );
  }
}
