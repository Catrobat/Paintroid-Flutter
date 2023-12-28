import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  const ColorBox({
    required this.color,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      height: 40,
      width: 40,
    );
  }
}
