import 'package:colorpicker/src/components/slider_indicator.dart';
import 'package:flutter/material.dart';

class OpacitySlider extends StatefulWidget {
  const OpacitySlider({
    super.key,
    required this.gradientColor,
    required this.callback,
  });

  final Color gradientColor;
  final Function(Color, double) callback;

  @override
  State<OpacitySlider> createState() => _OpacitySliderState();
}

class _OpacitySliderState extends State<OpacitySlider> {
  double _sliderPosition = 0.0;
  double _positionFraction = 0.0;

  void _handleColorChange(double position, double widgetWidth) {
    if (position < 0.0) {
      position = 0.0;
    }
    if (position > widgetWidth) {
      position = widgetWidth;
    }
    setState(() {
      _sliderPosition = position;
      _positionFraction = _sliderPosition / widgetWidth;
      widget.callback(
        widget.gradientColor,
        1 - _positionFraction,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double widgetWidth = MediaQuery.of(context).size.width - 52.0;
    return Container(
      height: 25.0,
      width: widgetWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'packages/component_library/assets/img/checkerboard.png',
          ),
          fit: BoxFit.fitHeight,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {},
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          double position = details.localPosition.dx;
          _handleColorChange(position, widgetWidth);
        },
        onHorizontalDragEnd: (DragEndDetails details) {},
        onTapDown: (TapDownDetails details) {
          double position = details.localPosition.dx;
          _handleColorChange(position, widgetWidth);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.gradientColor,
                widget.gradientColor.withOpacity(0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: CustomPaint(
            painter: SliderIndicatorPainter(_sliderPosition),
          ),
        ),
      ),
    );
  }
}
