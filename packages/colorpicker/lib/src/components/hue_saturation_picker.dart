import 'dart:math';
import 'package:colorpicker/src/components/hue_slider_painter.dart';
import 'package:colorpicker/src/components/saturation_value_painter.dart';
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
                  painter: SaturationValuePainter(
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
                  painter: HueSliderPainter(
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
