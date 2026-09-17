import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';


class BottomNavItemData {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  const BottomNavItemData({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

class OnboardingPageBottomNavigationBar extends StatefulWidget {
  final List<BottomNavItemData> items;

  const OnboardingPageBottomNavigationBar(
      {super.key, required this.items});

  @override
  State<OnboardingPageBottomNavigationBar> createState() =>
      _OnboardingPageBottomNavigationBarState();
}

class _OnboardingPageBottomNavigationBarState extends State<OnboardingPageBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final theme = PaintroidTheme.of(context);

    return Row(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];

        return Expanded(
          child: Container(
            color: theme.surfaceColor,
            child: InkWell(
              onTap: () {
                item.onPressed();
                setState(() =>index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        color: theme.onSurfaceColor
                      ),
                      child: item.icon,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      }),
    );
  }
}