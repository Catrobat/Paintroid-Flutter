import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomControlNavigationBar extends StatelessWidget {
  static const height = 64.0;

  const BottomControlNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          const NavigationDestination(
            label: "Tools",
            icon: _BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          const NavigationDestination(
            label: "Brush",
            icon: _BottomBarIcon(asset: 'assets/svg/ic_brush.svg'),
          ),
          NavigationDestination(
            label: "Color",
            icon: Icon(
              Icons.check_box_outline_blank,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const NavigationDestination(
            label: "Layers",
            icon: _BottomBarIcon(asset: 'assets/svg/ic_layers.svg'),
          ),
        ],
      ),
    );
  }
}

class _BottomBarIcon extends StatelessWidget {
  final String asset;

  const _BottomBarIcon({required this.asset});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      height: 24,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
