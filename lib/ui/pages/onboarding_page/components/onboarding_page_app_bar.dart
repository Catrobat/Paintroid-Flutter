import 'package:flutter/material.dart';

class OnboardingPageAppBar extends AppBar {
  final List<VoidCallback> onPressed;

  OnboardingPageAppBar({
    super.key,
    required String title,
    required this.onPressed,
  }) : super(
          title: Text(title),
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              key: const Key('undoButton'),
              onPressed: onPressed[0],
              icon: const Icon(Icons.undo),
            ),
            IconButton(
              key: const Key('redoButton'),
              onPressed: onPressed[1],
              icon: const Icon(Icons.redo),
            ),
          ],
        );
}
