import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconSvg extends StatelessWidget {
  final String path;
  final double height;
  final double width;
  final Color? color; // Make the color nullable

  const IconSvg({
    Key? key,
    required this.path,
    required this.height,
    required this.width,
    this.color, // Remove the required keyword
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: SvgPicture.asset(
        'packages/component_library/$path',
        height: height,
        width: width,
        color: color, // Pass the nullable color
      ),
    );
  }
}
