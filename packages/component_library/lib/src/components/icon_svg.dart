// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

class IconSvg extends StatelessWidget {
  final String path;
  final double height;
  final double width;
  final Color? color;

  const IconSvg({
    Key? key,
    required this.path,
    required this.height,
    required this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'packages/component_library/$path',
      height: height,
      width: width,
      color: color,
    );
  }
}
