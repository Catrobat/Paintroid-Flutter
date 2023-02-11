import 'package:flutter/material.dart';
import 'package:paintroid/ui/shared/overflow_menu.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: [const OverflowMenu()],
        );
}
