import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/tool_options.dart';

class BrushToolOptions extends ConsumerStatefulWidget {
  const BrushToolOptions({Key? key}) : super(key: key);

  @override
  ConsumerState<BrushToolOptions> createState() => _BrushToolOptionsState();
}

class _BrushToolOptionsState extends ConsumerState<BrushToolOptions> {
  double _strokeWidth = 25;
  StrokeCap _strokeCap = StrokeCap.round;

  @override
  Widget build(BuildContext context) {
    final optionsVisible = ref.watch(ToolState.provider).areOptionsVisible;
    return Stack(
      children: [
        AnimatedPositioned(
          top: optionsVisible ? 0 : -50,
          left: 0,
          right: 0,
          duration: ToolOptions.toggleAnimDuration,
          curve: ToolOptions.toggleAnimCurve,
          child: _strokeWidthSlider,
        ),
        AnimatedPositioned(
          bottom: optionsVisible ? 0 : -50,
          left: 0,
          right: 0,
          duration: ToolOptions.toggleAnimDuration,
          curve: ToolOptions.toggleAnimCurve,
          child: _strokeCapAndWidthVisualizer,
        ),
      ],
    );
  }

  Widget get _strokeCapAndWidthVisualizer {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 8,
            children: [
              _buildStrokeCapChoiceChip(Icons.circle, StrokeCap.round),
              _buildStrokeCapChoiceChip(Icons.square, StrokeCap.square),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            width: 100,
            child: CustomPaint(
              painter: _StrokePainter(
                  _strokeWidth, _strokeCap, const Color(0xFF808080)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeCapChoiceChip(IconData icon, StrokeCap cap) {
    final brushTool = ref.watch(BrushTool.provider);
    return ChoiceChip(
      label: Icon(icon),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(width: 0.25)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      selectedColor: Theme.of(context).primaryColor,
      selected: _strokeCap == cap,
      onSelected: (selected) {
        if (selected && _strokeCap != cap) {
          setState(() {
            _strokeCap = cap;
            brushTool.paint.strokeCap = cap;
          });
        }
      },
    );
  }

  Widget get _strokeWidthSlider {
    final brushTool = ref.watch(BrushTool.provider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "${_strokeWidth.toInt()}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: _strokeWidth,
              min: 1,
              max: 100,
              divisions: 100,
              onChanged: (val) => setState(() => _strokeWidth = val),
              onChangeEnd: (val) => brushTool.paint.strokeWidth = val,
            ),
          )
        ],
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
