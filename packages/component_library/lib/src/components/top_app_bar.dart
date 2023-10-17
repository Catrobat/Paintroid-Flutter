import 'package:component_library/src/components/overflow_menu.dart';
import 'package:flutter/material.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: [const OverflowMenu()],
        );
}
