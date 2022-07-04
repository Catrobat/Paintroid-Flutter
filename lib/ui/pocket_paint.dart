import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/provider/state_providers.dart';
import 'package:paintroid/ui/top_app_bar.dart';

import 'bottom_control_navigation_bar.dart';
import 'drawing_board.dart';

class PocketPaint extends ConsumerWidget {
  const PocketPaint({Key? key}) : super(key: key);

  void _toggleStatusBar(bool isFullscreen) {
    SystemChrome.setEnabledSystemUIMode(
      isFullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullscreen = ref.watch(StateProviders.isFullscreen);
    ref.listen<bool>(
      StateProviders.isFullscreen,
      (_, isFullscreen) => _toggleStatusBar(isFullscreen),
    );
    return WillPopScope(
      onWillPop: () async {
        final willPop = !isFullscreen;
        if (isFullscreen) {
          ref.read(StateProviders.isFullscreen.notifier).state = false;
        }
        return willPop;
      },
      child: Scaffold(
        appBar: isFullscreen ? null : TopAppBar(title: "Pocket Paint"),
        body: SafeArea(
          child: Stack(
            children: [
              const DrawingBoard(),
              if (isFullscreen) _exitFullscreenButton,
            ],
          ),
        ),
        bottomNavigationBar:
            isFullscreen ? null : const BottomControlNavigationBar(),
      ),
    );
  }

  Positioned get _exitFullscreenButton {
    return Positioned(
      top: 2,
      right: 2,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final isUserDrawing = ref.watch(StateProviders.isUserDrawing);
          return AnimatedOpacity(
            opacity: isUserDrawing ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () {
                ref.read(StateProviders.isFullscreen.notifier).state = false;
              },
              icon: const Icon(Icons.fullscreen_exit),
            ),
          );
        },
      ),
    );
  }
}
