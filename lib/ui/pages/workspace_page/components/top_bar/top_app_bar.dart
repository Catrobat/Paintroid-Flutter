// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';

// Project imports:

class TopAppBar extends AppBar {
  TopAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: [const OverflowMenu()],
        );
}
