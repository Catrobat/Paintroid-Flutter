import 'package:flutter/material.dart';

class SliderIndicatorShape extends SliderComponentShape {
  SliderIndicatorShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(5.0, 26.0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: 5.0,
        height: 26.0,
      ),
      Paint()
        ..color = const Color.fromARGB(255, 62, 62, 62)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackWidth = parentBox.size.width;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(offset.dx, trackTop, trackWidth, trackHeight);
  }
}
