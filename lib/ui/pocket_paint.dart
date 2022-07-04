import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paintroid/ui/top_app_bar.dart';

import 'bottom_control_navigation_bar.dart';
import 'drawing_board.dart';

class PocketPaint extends StatefulWidget {
  const PocketPaint({Key? key}) : super(key: key);

  @override
  State<PocketPaint> createState() => _PocketPaintState();
}

class _PocketPaintState extends State<PocketPaint> {
  bool _isFullscreen = false;
  bool _isDrawing = false;

  void _toggleOnFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    setState(() => _isFullscreen = true);
  }

  void _toggleOffFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    setState(() => _isFullscreen = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final willPop = !_isFullscreen;
        if (_isFullscreen) _toggleOffFullscreen();
        return willPop;
      },
      child: Scaffold(
        appBar: _isFullscreen
            ? null
            : TopAppBar(
                title: "Pocket Paint",
                onFullscreenPressed: _toggleOnFullscreen,
              ),
        body: SafeArea(
          child: Stack(
            children: [
              DrawingBoard(
                startedDrawing: () => setState(() => _isDrawing = true),
                stoppedDrawing: () => setState(() => _isDrawing = false),
              ),
              if (_isFullscreen) _exitFullscreenButton,
            ],
          ),
        ),
        bottomNavigationBar:
            _isFullscreen ? null : const BottomControlNavigationBar(),
      ),
    );
  }

  Positioned get _exitFullscreenButton {
    return Positioned(
      top: 2,
      right: 2,
      child: AnimatedOpacity(
        opacity: _isDrawing ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          onPressed: _toggleOffFullscreen,
          icon: const Icon(Icons.fullscreen_exit),
        ),
      ),
    );
  }
}
