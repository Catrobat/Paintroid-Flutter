import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
