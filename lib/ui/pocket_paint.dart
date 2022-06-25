import 'package:flutter/material.dart';

import 'custom_navigation_bar.dart';
import 'drawing_board.dart';

class PocketPaint extends StatelessWidget {
  final String title;

  const PocketPaint({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
      ),
      body: const DrawingBoard(),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
