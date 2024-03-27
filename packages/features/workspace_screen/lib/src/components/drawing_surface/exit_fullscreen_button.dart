import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tools/tools.dart';
import 'package:workspace_screen/workspace_screen.dart';

class ExitFullscreenButton extends ConsumerWidget {
  const ExitFullscreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserDrawing = ref.watch(
      toolBoxStateProvider.select((state) => state.isDown),
    );
    return AnimatedOpacity(
      opacity: isUserDrawing ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        onPressed: () {
          ref.read(WorkspaceState.provider.notifier).toggleFullscreen(false);
        },
        icon: Icon(
          Icons.fullscreen_exit,
          color: PaintroidTheme.of(context).shadowColor,
        ),
      ),
    );
  }
}
