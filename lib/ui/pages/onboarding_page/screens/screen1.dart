import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';


class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PaintroidTheme.of(context).surfaceColor,
      padding: const EdgeInsets.only(top: 100, left: 50, right: 50),
      child: Column(
        children: [
          Text(
            'Welcome To Pocket Paint',
            style: TextStyle(
              color: PaintroidTheme.of(context).onSurfaceColor,
              fontSize: 25,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'With Pocket Paint there are no limits to your creativity. If you are new, start the intro, or skip it if you are already familiar with Pocket Paint.',
              style: TextStyle(
                color: PaintroidTheme.of(context).onSurfaceColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
