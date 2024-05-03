// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toast/toast.dart';

// Project imports:
import 'package:paintroid/core/providers/object/io_handler.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/drawing_canvas.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/exit_fullscreen_button.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:paintroid/ui/shared/discard_changes_dialog.dart';

// Project imports:

class WorkspacePage extends ConsumerStatefulWidget {
  const WorkspacePage({super.key});

  @override
  ConsumerState<WorkspacePage> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspacePage> {
  void _toggleStatusBar(bool isFullscreen) {
    SystemChrome.setEnabledSystemUIMode(
      isFullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    final isFullscreen = ref.watch(
      WorkspaceState.provider.select((state) => state.isFullscreen),
    );
    ref.listen<bool>(
      WorkspaceState.provider.select((state) => state.isFullscreen),
      (_, isFullscreen) => _toggleStatusBar(isFullscreen),
    );
    final ioHandler = ref.watch(IOHandler.provider);
    final workspaceStateNotifier = ref.watch(WorkspaceState.provider.notifier);
    return PopScope(
      canPop: !isFullscreen && workspaceStateNotifier.hasSavedLastWork,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        if (isFullscreen) {
          workspaceStateNotifier.toggleFullscreen(false);
          return;
        }

        if (!workspaceStateNotifier.hasSavedLastWork) {
          final shouldDiscard = await showDiscardChangesDialog(context);
          if (shouldDiscard != null) {
            if (!shouldDiscard && context.mounted) {
              ioHandler.saveImage(context);
            }
          }
        }
      },
      child: Scaffold(
        appBar: isFullscreen ? null : TopAppBar(title: 'Pocket Paint'),
        backgroundColor: Colors.grey.shade400,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const DrawingCanvas(),
            if (isFullscreen)
              const Positioned(
                top: 2,
                right: 2,
                child: SafeArea(child: ExitFullscreenButton()),
              )
            else
              const ToolOptions(),
          ],
        ),
        bottomNavigationBar: isFullscreen ? null : const BottomNavBar(),
      ),
    );
  }
}
