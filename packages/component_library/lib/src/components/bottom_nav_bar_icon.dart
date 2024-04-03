// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:component_library/component_library.dart';

class BottomBarIcon extends StatelessWidget {
  final String asset;

  const BottomBarIcon({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconSvg(
      path: asset,
      height: 24.0,
      width: 24.0,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
