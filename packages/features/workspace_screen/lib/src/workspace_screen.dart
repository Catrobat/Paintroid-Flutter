// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:toast/toast.dart';

// Project imports:
import 'package:workspace_screen/workspace_screen.dart';

class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
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

    return WillPopScope(
      onWillPop: () async {
        var willPop = !isFullscreen;
        if (isFullscreen) {
          ref.read(WorkspaceState.provider.notifier).toggleFullscreen(false);
        } else {
          final workspaceStateNotifier =
              ref.watch(WorkspaceState.provider.notifier);
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
