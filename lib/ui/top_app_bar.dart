import 'package:flutter/material.dart';

class TopAppBar extends AppBar {
  final VoidCallback onFullscreenPressed;

  TopAppBar({
    Key? key,
    required String title,
    required this.onFullscreenPressed,
  }) : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: onFullscreenPressed,
              icon: const Icon(Icons.fullscreen),
            )
          ],
        );
}
