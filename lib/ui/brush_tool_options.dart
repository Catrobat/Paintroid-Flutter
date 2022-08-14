import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/tool_options.dart';

class BrushToolOptions extends ConsumerStatefulWidget {
  const BrushToolOptions({Key? key}) : super(key: key);

  @override
  ConsumerState<BrushToolOptions> createState() => _BrushToolOptionsState();
}

class _BrushToolOptionsState extends ConsumerState<BrushToolOptions> {
  late final _brushPaint = ref.read(BrushTool.provider).paint;
  late final _textEditingController = TextEditingController(
    text: "${_brushPaint.strokeWidth.toInt()}",
  );

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
                _brushPaint.strokeWidth,
                _brushPaint.strokeCap,
                _brushPaint.color,
              ),
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
      selected: _brushPaint.strokeCap == cap,
      onSelected: (selected) {
        if (selected && _brushPaint.strokeCap != cap) {
          setState(() {
            _brushPaint.strokeCap = cap;
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
          TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              constraints: BoxConstraints(maxWidth: 55),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                final num = int.parse(newValue.text);
                return num >= 1 && num <= 100 ? newValue : oldValue;
              }),
            ],
            autocorrect: false,
            expands: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (text) {
              if (text.isEmpty) return;
              setState(() {
                _brushPaint.strokeWidth = double.parse(text);
                brushTool.paint.strokeWidth = _brushPaint.strokeWidth;
              });
            },
            onSubmitted: (text) {
              if (text.isNotEmpty) return;
              _textEditingController.text = "${_brushPaint.strokeWidth.toInt()}";
            },
          ),
          Expanded(
            child: Slider(
              value: _brushPaint.strokeWidth,
              min: 1,
              max: 100,
              divisions: 100,
              onChanged: (val) => setState(() {
                _brushPaint.strokeWidth = val;
                _textEditingController.text = "${val.toInt()}";
              }),
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
