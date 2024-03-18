import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PaintroidTheme.of(context).surfaceColor,
      padding: const EdgeInsets.only(top: 100, left: 50, right: 50),
      child: Column(
        children: [
          const Text(
            'Welcome To Pocket Paint',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: const Text(
              'With Pocket Paint there are no limits to your creativity. If you are new, start the intro, or skip it if you are already familiar with Pocket Paint.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
