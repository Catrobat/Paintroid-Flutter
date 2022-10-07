import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/tool_options/brush/brush_options_state.dart';

class StrokeWidthVisualizer extends ConsumerWidget {
  const StrokeWidthVisualizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brushOptions = ref.watch(BrushOptionsState.provider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 100,
      child: CustomPaint(
        painter: _StrokePainter(
          brushOptions.strokeWidth,
          brushOptions.strokeCap,
          brushOptions.color,
        ),
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  _StrokePainter(this._width, this._cap, this._color);

  final double _width;
  final StrokeCap _cap;
  final Color _color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _color
      ..strokeCap = _cap
      ..strokeWidth = _width * 0.4;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) =>
      _width != oldDelegate._width || _cap != oldDelegate._cap;
}
