import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IconButtonWithLabel extends StatelessWidget {
  final String svgAssetPath;
  final String label;
  final Color? color;

  const IconButtonWithLabel({
    super.key,
    required this.svgAssetPath,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: Column(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              svgAssetPath,
              height: 24,
              width: 24,
              color: color ?? Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: label);
            },
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
