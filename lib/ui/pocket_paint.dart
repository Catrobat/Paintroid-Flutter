import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'drawing_board.dart';

class PocketPaint extends StatefulWidget {
  final String title;

  const PocketPaint({Key? key, required this.title}) : super(key: key);

  @override
  State<PocketPaint> createState() => _PocketPaintState();
}

class _PocketPaintState extends State<PocketPaint> {
  bool _isFullscreen = false;

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
              const DrawingBoard(),
              if (_isFullscreen)
                Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                    onPressed: () => _toggleOffFullscreen(),
                    icon: const Icon(Icons.fullscreen_exit),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar:
            _isFullscreen ? null : const _BottomNavigationBar(),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      items: [
        BottomNavigationBarItem(
          label: "Tools",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.handyman),
          ),
        ),
        BottomNavigationBarItem(
          label: "Brush",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brush),
          ),
        ),
        BottomNavigationBarItem(
          label: "Color",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.square),
          ),
        ),
        BottomNavigationBarItem(
          label: "Layers",
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.layers),
          ),
        )
      ],
    );
  }
}
