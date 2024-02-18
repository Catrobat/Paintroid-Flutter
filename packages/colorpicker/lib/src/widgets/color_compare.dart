import 'package:flutter/material.dart';

class ColorCompare extends StatefulWidget {
  const ColorCompare({
    super.key,
    required this.currentColor,
    required this.newColor,
  });

  final Color currentColor;
  final Color newColor;

  @override
  State<ColorCompare> createState() => _ColorCompareState();
}

class _ColorCompareState extends State<ColorCompare> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.0,
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            child: ColorDesc(
              color: widget.currentColor,
              desc: 'current',
            ),
          ),
          Expanded(
            child: ColorDesc(
              color: widget.newColor,
              desc: 'new',
            ),
          ),
        ],
      ),
    );
  }
}

class ColorDesc extends StatelessWidget {
  const ColorDesc({
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
