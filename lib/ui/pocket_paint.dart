import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_navigation_bar.dart';
import 'drawing_board.dart';

class PocketPaint extends StatefulWidget {
  final String title;

  const PocketPaint({Key? key, required this.title}) : super(key: key);

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
        if (_isFullscreen) {
          _toggleOffFullscreen();
        }
        return willPop;
      },
      child: Scaffold(
        appBar: _isFullscreen
            ? null
            : AppBar(
                title: Text(widget.title),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () => _toggleOnFullscreen(),
                    icon: const Icon(Icons.fullscreen),
                  )
                ],
              ),
        body: SafeArea(
          child: Stack(
            children: [
              DrawingBoard(
                startedDrawing: () => setState(() => _isDrawing = true),
                stoppedDrawing: () => setState(() => _isDrawing = false),
              ),
              if (_isFullscreen)
                Positioned(
                  top: 2,
                  right: 2,
                  child: AnimatedOpacity(
                    opacity: _isDrawing ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: () => _toggleOffFullscreen(),
                      icon: const Icon(Icons.fullscreen_exit),
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar:
            _isFullscreen ? null : const CustomNavigationBar(),
      ),
    );
  }
}
