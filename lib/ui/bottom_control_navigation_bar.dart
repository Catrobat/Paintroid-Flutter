import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paintroid/core/app_localizations.dart';

class BottomControlNavigationBar extends StatelessWidget {
  static const height = 64.0;

  const BottomControlNavigationBar({Key? key}) : super(key: key);

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

class BottomBarIcon extends StatelessWidget {
  final String asset;

  const BottomBarIcon({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      height: 24,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
