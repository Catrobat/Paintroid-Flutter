import 'package:flutter/material.dart';

import 'drawing_board.dart';

class PocketPaint extends StatelessWidget {
  final String title;

  const PocketPaint({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: false),
      body: const Center(child: DrawingBoard()),
      bottomNavigationBar: const _BottomNavigationBar(),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      items: [
        BottomNavigationBarItem(
          label: "Tools",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.handyman),
          ),
        ),
        BottomNavigationBarItem(
          label: "Brush",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brush),
          ),
        ),
        BottomNavigationBarItem(
          label: "Color",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.square),
          ),
        ),
        BottomNavigationBarItem(
          label: "Layers",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.layers),
          ),
        )
      ],
    );
  }
}
