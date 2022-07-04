import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/provider/state_providers.dart';

class TopAppBar extends AppBar {
  TopAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(title),
          centerTitle: false,
          actions: [
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return IconButton(
                  onPressed: () => ref
                      .read(StateProviders.isFullscreen.notifier)
                      .state = true,
                  icon: const Icon(Icons.fullscreen),
                );
              },
            )
          ],
        );
}
