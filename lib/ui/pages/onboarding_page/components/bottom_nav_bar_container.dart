// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_bottom_nav_bar.dart';
import 'package:paintroid/ui/theme/theme.dart';

class BottomNavigationBarContainer extends StatelessWidget {
  final List<BottomNavigationBarItem> navBarItems;
  final List<VoidCallback> onPressedFunctions;

  const BottomNavigationBarContainer({
    super.key,
    required this.navBarItems,
    required this.onPressedFunctions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: PaintroidTheme.of(context).surfaceColor,
      child: OnboardingPageBottomNavigationBar(
        onPressedFunctions: onPressedFunctions,
        barItems: navBarItems,
      ),
    );
  }
}
