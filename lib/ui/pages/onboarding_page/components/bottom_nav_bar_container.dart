import 'package:flutter/material.dart';

import 'package:paintroid/ui/pages/onboarding_page/components/onboarding_page_bottom_nav_bar.dart';
import 'package:paintroid/ui/theme/theme.dart';

class BottomNavigationBarContainer extends StatelessWidget {
  final List<BottomNavItemData> items;

  const BottomNavigationBarContainer({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: PaintroidTheme.of(context).surfaceColor,
      child: OnboardingPageBottomNavigationBar(
        items: items,
      ),
    );
  }
}