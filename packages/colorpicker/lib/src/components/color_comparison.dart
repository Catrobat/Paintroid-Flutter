import 'package:flutter/material.dart';

class ColorComparison extends StatelessWidget {
  const ColorComparison({
    super.key,
    required this.currentColor,
    required this.newColor,
  });

  final Color currentColor;
  final Color newColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.0,
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            child: ColorDescription(
              color: currentColor,
              desc: 'current',
            ),
          ),
          Expanded(
            child: ColorDescription(
              color: newColor,
              desc: 'new',
            ),
          ),
        ],
      ),
    );
  }
}

class ColorDescription extends StatelessWidget {
  const ColorDescription({
    super.key,
    required this.color,
    required this.desc,
  });

  final Color color;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: color,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          desc,
          style: const TextStyle(color: Color.fromARGB(255, 149, 149, 149)),
        ),
      ],
    );
  }
}
