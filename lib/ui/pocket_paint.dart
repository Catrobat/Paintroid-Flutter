import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';
import 'bottom_bar.dart';
import 'drawing_board.dart';

class PocketPaint extends StatelessWidget {
  final String title;

  const PocketPaint({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: AppTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: const DrawingBoard(),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
