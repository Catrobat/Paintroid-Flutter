import 'package:flutter/material.dart';

import 'overflow_menu.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: const [
            RotatedBox(
              quarterTurns: 1,
              child: OverflowMenu(),
            )
          ],
        );
}
