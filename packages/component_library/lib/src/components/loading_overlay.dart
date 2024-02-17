import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final Widget? child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    this.child,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutQuad,
  ));
  bool _overlayVisible = false;

  @override
  void initState() {
    super.initState();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() => _overlayVisible = true);
      }
      if (status == AnimationStatus.dismissed) {
        setState(() => _overlayVisible = false);
      }
    });
    if (widget.isLoading) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLoading && widget.isLoading) {
      _controller.forward();
    }
    if (oldWidget.isLoading && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (_overlayVisible == true)
          FadeTransition(
            opacity: _animation,
            child: const Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                ),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
      ],
    );
  }
}
