// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/theme/theme.dart';

class ExitFullscreenButton extends ConsumerWidget {
  const ExitFullscreenButton({super.key});

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
