import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/provider/state_providers.dart';

class EnterFullscreenButton extends ConsumerWidget {
  const EnterFullscreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(StateProviders.isFullscreen.notifier)
          .state = true,
      icon: const Icon(Icons.fullscreen),
    );
  }
}

