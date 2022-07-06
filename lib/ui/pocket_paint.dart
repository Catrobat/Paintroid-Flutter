import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/top_app_bar.dart';
import 'package:paintroid/workspace/workspace.dart';

import 'bottom_control_navigation_bar.dart';
import 'drawing_board.dart';
import 'exit_fullscreen_button.dart';

class PocketPaint extends ConsumerWidget {
  const PocketPaint({Key? key}) : super(key: key);

  void _toggleStatusBar(bool isFullscreen) {
    SystemChrome.setEnabledSystemUIMode(
      isFullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullscreen = ref.watch(
      WorkspaceStateNotifier.provider.select((state) => state.isFullscreen),
    );
    ref.listen<bool>(
      WorkspaceStateNotifier.provider.select((state) => state.isFullscreen),
      (_, isFullscreen) => _toggleStatusBar(isFullscreen),
    );
    return WillPopScope(
      onWillPop: () async {
        final willPop = !isFullscreen;
        if (isFullscreen) {
          ref
              .read(WorkspaceStateNotifier.provider.notifier)
              .toggleFullscreen(false);
        }
        return willPop;
      },
      child: Scaffold(
        appBar: isFullscreen ? null : TopAppBar(title: "Pocket Paint"),
        backgroundColor: Colors.grey.shade400,
        body: SafeArea(
          child: Stack(
            children: [
              const Center(child: DrawingBoard()),
              if (isFullscreen)
                const Positioned(
                  top: 2,
                  right: 2,
                  child: ExitFullscreenButton(),
                ),
            ],
          ),
        ),
        bottomNavigationBar:
            isFullscreen ? null : const BottomControlNavigationBar(),
      ),
    );
  }
}
