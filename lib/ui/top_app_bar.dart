import 'package:flutter/material.dart';

import 'enter_fullscreen_button.dart';
import 'save_image_button.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: const [
            SaveImageButton(),
            EnterFullscreenButton(),
          ],
        );
}
