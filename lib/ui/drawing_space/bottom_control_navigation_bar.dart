import 'package:flutter/material.dart';
import 'package:paintroid/core/app_localizations.dart';
import 'package:paintroid/ui/drawing_space/tools_bottom_sheet.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';

class BottomControlNavigationBar extends StatelessWidget {
  static const height = 64.0;

  const BottomControlNavigationBar({Key? key}) : super(key: key);

  void _onNavigationItemSelected(int index, BuildContext context) {
    if (index == 0) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const ToolsBottomSheet();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      child: NavigationBar(
        height: height,
        onDestinationSelected: (index) =>
            _onNavigationItemSelected(index, context),
        destinations: [
          NavigationDestination(
            label: localizations.tools,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          NavigationDestination(
            label: localizations.brush,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_brush.svg'),
          ),
          NavigationDestination(
            label: localizations.color,
            icon: Icon(
              Icons.check_box_outline_blank,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          NavigationDestination(
            label: localizations.layers,
            icon: const BottomBarIcon(asset: 'assets/svg/ic_layers.svg'),
          ),
        ],
      ),
    );
  }
}
