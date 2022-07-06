import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/workspace/workspace.dart';

class ExitFullscreenButton extends ConsumerWidget {
  const ExitFullscreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserDrawing = ref.watch(
      WorkspaceStateNotifier.provider.select((state) => state.isUserDrawing),
    );
    return AnimatedOpacity(
      opacity: isUserDrawing ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        onPressed: () {
          ref
              .read(WorkspaceStateNotifier.provider.notifier)
              .toggleFullscreen(false);
        },
        icon: const Icon(Icons.fullscreen_exit),
      ),
    );
  }
}
