import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/ui/top_app_bar.dart';
import 'package:paintroid/workspace/workspace.dart';

import 'bottom_control_navigation_bar.dart';
import 'exit_fullscreen_button.dart';
import 'io_handler.dart';

class PocketPaint extends ConsumerStatefulWidget {
  const PocketPaint({Key? key}) : super(key: key);

  @override
  ConsumerState<PocketPaint> createState() => _PocketPaintState();
}

class _PocketPaintState extends ConsumerState<PocketPaint> {
  void _toggleStatusBar(bool isFullscreen) {
    SystemChrome.setEnabledSystemUIMode(
      isFullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFullscreen = ref.watch(
      WorkspaceState.provider.select((state) => state.isFullscreen),
    );
    ref.listen<bool>(
      WorkspaceState.provider.select((state) => state.isFullscreen),
      (_, isFullscreen) => _toggleStatusBar(isFullscreen),
    );
    final ioHandler = ref.watch(IOHandler.provider);

    return WillPopScope(
      onWillPop: () async {
        var willPop = !isFullscreen;
        if (isFullscreen) {
          ref.read(WorkspaceState.provider.notifier).toggleFullscreen(false);
        } else {
          final workspaceStateNotifier = ref.watch(WorkspaceState.provider.notifier);
          if (!workspaceStateNotifier.hasSavedLastWork) {
            final shouldDiscard = await showDiscardChangesDialog(context);
            if (shouldDiscard != null) {
              if (!shouldDiscard && mounted) {
                ioHandler.saveImage(context);
              }
              willPop = shouldDiscard;
            } else {
              willPop = false;
            }
          }
        }
        return willPop;
      },
      child: Scaffold(
        appBar: isFullscreen ? null : TopAppBar(title: "Pocket Paint"),
        backgroundColor: Colors.grey.shade400,
        body: SafeArea(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Transform.scale(
                    scale: ref.watch(CanvasState.provider).scale,
                    child: const DrawingCanvas(),
                  ),
                ),
              ),
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
