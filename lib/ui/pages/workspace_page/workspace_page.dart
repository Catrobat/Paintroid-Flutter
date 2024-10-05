import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/drawing_canvas.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/exit_fullscreen_button.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:toast/toast.dart';

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
      workspaceStateProvider.select((state) => state.isFullscreen),
    );
    ref.listen<bool>(
      workspaceStateProvider.select((state) => state.isFullscreen),
      (_, isFullscreen) => _toggleStatusBar(isFullscreen),
    );
    return PopScope(
      child: Scaffold(
        appBar: isFullscreen ? null : const TopAppBar(title: 'Pocket Paint'),
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
