import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'theme.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: BottomNavigationBar(
        backgroundColor: AppTheme.primary,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedLabelStyle: AppTheme.labelTextStyle,
        unselectedLabelStyle: AppTheme.labelTextStyle,
        fixedColor: AppTheme.labelColor,
        unselectedItemColor: AppTheme.labelColor,
        items: const [
          BottomNavigationBarItem(
            label: "Tools",
            icon: _BottomBarIcon(asset: 'assets/svg/ic_tools.svg'),
          ),
          BottomNavigationBarItem(
            label: "Brush",
            icon: _BottomBarIcon(
              asset: 'assets/svg/ic_brush.svg',
            ),
          ),
          BottomNavigationBarItem(
            label: "Colour",
            icon: Padding(
              padding:
                  EdgeInsets.only(bottom: 2.0, left: 2.0, right: 2.0, top: 2.0),
              child: Icon(
                Icons.check_box_outline_blank,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Layers",
            icon: _BottomBarIcon(
              asset: 'assets/svg/ic_layers.svg',
            ),
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
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 2.0, left: 2.0, right: 2.0, top: 2.0),
      child: SvgPicture.asset(
        asset,
        height: 22,
        color: Colors.white,
      ),
    );
  }
}
