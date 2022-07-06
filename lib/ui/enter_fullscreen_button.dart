import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/workspace/workspace.dart';

class EnterFullscreenButton extends ConsumerWidget {
  const EnterFullscreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(WorkspaceStateNotifier.provider.notifier)
          .toggleFullscreen(true),
      icon: const Icon(Icons.fullscreen),
    );
  }
}
