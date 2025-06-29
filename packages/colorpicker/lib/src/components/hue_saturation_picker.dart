import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HueSaturationValuePicker extends ConsumerStatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const HueSaturationValuePicker({
    Key? key,
    required this.initialColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  ConsumerState<HueSaturationValuePicker> createState() =>
      _HueSaturationValuePickerState();
}

class _HueSaturationValuePickerState
    extends ConsumerState<HueSaturationValuePicker> {
  late HSVColor _currentHsvColor;
  late Offset _svThumbPosition;
  late double _hueSliderThumbY;

  double _currentPickerSquareSize = 0.0;

  @override
  void initState() {
    super.initState();
    _currentHsvColor = HSVColor.fromColor(widget.initialColor);
    _svThumbPosition = Offset.zero;
    _hueSliderThumbY = 0.0;
  }

  @override
  void didUpdateWidget(HueSaturationValuePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      final newHsv = HSVColor.fromColor(widget.initialColor);
      if (newHsv != _currentHsvColor) {
        _currentHsvColor = newHsv;
        _updateThumbPositions(
            _currentPickerSquareSize, _currentPickerSquareSize);
      }
    }
  }

  void _updateThumbPositions(double pickerSquareSize, double hueSliderHeight) {
    _currentPickerSquareSize = pickerSquareSize;

    _svThumbPosition = Offset(
      _currentHsvColor.saturation * pickerSquareSize,
      (1.0 - _currentHsvColor.value) * pickerSquareSize,
    );
    _hueSliderThumbY = (_currentHsvColor.hue / 360.0) * hueSliderHeight;
    if (mounted) {
      setState(() {});
    }
  }

  void _handleSaturationValueChange(
      Offset localPosition, double pickerSquareSize) {
    double s = (localPosition.dx / pickerSquareSize).clamp(0.0, 1.0);
    double v = (1.0 - (localPosition.dy / pickerSquareSize)).clamp(0.0, 1.0);
    setState(() {
      _currentHsvColor = _currentHsvColor.withSaturation(s).withValue(v);
      _updateThumbPositions(pickerSquareSize, pickerSquareSize);
    });
    widget.onColorChanged(_currentHsvColor.toColor());
  }

  void _handleHueChange(Offset localPosition, double hueSliderHeight) {
    double hue =
        (localPosition.dy / hueSliderHeight * 360.0).clamp(0.0, 359.999);
    setState(() {
      _currentHsvColor = _currentHsvColor.withHue(hue);
      _updateThumbPositions(_currentPickerSquareSize, hueSliderHeight);
    });
    widget.onColorChanged(_currentHsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double pickerSquareSize = constraints.maxWidth * 0.7;
        final double hueSliderWidth = max(25.0, pickerSquareSize * 0.12);
        final double spacing = pickerSquareSize * 0.05;

        if (pickerSquareSize <= 0 || constraints.maxWidth <= 0) {
          return const SizedBox.shrink();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              (_currentPickerSquareSize != pickerSquareSize ||
                  _svThumbPosition == Offset.zero && _hueSliderThumbY == 0.0)) {
            _updateThumbPositions(pickerSquareSize, pickerSquareSize);
          }
        });

        if (pickerSquareSize <= 0) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: pickerSquareSize + hueSliderWidth + spacing,
          height: pickerSquareSize,
          child: Row(
            children: [
              GestureDetector(
                onPanDown: (details) => _handleSaturationValueChange(
                    details.localPosition, pickerSquareSize),
                onPanUpdate: (details) => _handleSaturationValueChange(
                    details.localPosition, pickerSquareSize),
                child: CustomPaint(
                  size: Size(pickerSquareSize, pickerSquareSize),
                  painter: _SaturationValuePainter(
                    hue: _currentHsvColor.hue,
                    thumbPosition: _svThumbPosition,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              GestureDetector(
                onPanDown: (details) =>
                    _handleHueChange(details.localPosition, pickerSquareSize),
                onPanUpdate: (details) =>
                    _handleHueChange(details.localPosition, pickerSquareSize),
                child: CustomPaint(
                  size: Size(hueSliderWidth, pickerSquareSize),
                  painter: _HueSliderPainter(
                    hueSliderThumbY: _hueSliderThumbY,
                    thumbColor: _currentHsvColor.toColor(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SaturationValuePainter extends CustomPainter {
  final double hue;
  final Offset thumbPosition;

  _SaturationValuePainter({required this.hue, required this.thumbPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Paint paintWhiteToHue = Paint()
      ..shader = LinearGradient(
        colors: [
          HSVColor.fromAHSV(1.0, hue, 0.0, 1.0).toColor(),
          HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect);
    canvas.drawRect(rect, paintWhiteToHue);

    final Paint paintTransparentToBlack = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Colors.black,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, paintTransparentToBlack);

    final Paint thumbPaintFill = Paint()..color = Colors.white;
    final Paint thumbPaintStroke = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const double thumbRadius = 6.0;

    final double clampedDx =
        thumbPosition.dx.clamp(thumbRadius, size.width - thumbRadius);
    final double clampedDy =
        thumbPosition.dy.clamp(thumbRadius, size.height - thumbRadius);
    final Offset clampedThumbPosition = Offset(clampedDx, clampedDy);

    canvas.drawCircle(clampedThumbPosition, thumbRadius, thumbPaintFill);
    canvas.drawCircle(clampedThumbPosition, thumbRadius, thumbPaintStroke);
  }

  @override
  bool shouldRepaint(_SaturationValuePainter oldDelegate) {
    return oldDelegate.hue != hue || oldDelegate.thumbPosition != thumbPosition;
  }
}

class _HueSliderPainter extends CustomPainter {
  final double hueSliderThumbY;
  final Color thumbColor;

  _HueSliderPainter({required this.hueSliderThumbY, required this.thumbColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final List<Color> hueColors = List.generate(
      360,
      (i) => HSVColor.fromAHSV(1.0, i.toDouble(), 1.0, 1.0).toColor(),
    );
    final Paint huePaint = Paint()
      ..shader = LinearGradient(
        colors: hueColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, huePaint);

    const double thumbWidthFactor = 0.1;
    const double thumbHeightFactor = 0.05;
    final double thumbHeight = size.height * thumbHeightFactor;

    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Paint thumbBorderPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double clampedThumbY =
        hueSliderThumbY.clamp(thumbHeight / 2, size.height - (thumbHeight / 2));
    final Rect thumbRect = Rect.fromCenter(
        center: Offset(size.width / 2, clampedThumbY),
        width: size.width + (size.width * thumbWidthFactor),
        height: thumbHeight);

    final RRect thumbRRect =
        RRect.fromRectAndRadius(thumbRect, const Radius.circular(2.0));
    canvas.drawRRect(thumbRRect, thumbPaint);
    canvas.drawRRect(thumbRRect, thumbBorderPaint);
  }

  @override
  bool shouldRepaint(_HueSliderPainter oldDelegate) {
    return oldDelegate.hueSliderThumbY != hueSliderThumbY ||
        oldDelegate.thumbColor != thumbColor;
  }
}
