// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:component_library/component_library.dart';

// Project imports:
import 'package:onboarding_screen/onboarding_screen.dart';

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
