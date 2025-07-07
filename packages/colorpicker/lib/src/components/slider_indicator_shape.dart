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
    final canvas = context.canvas;
    const thumbWidth = 5.0;
    const thumbHeight = 26.0;
    double dx = center.dx;

    if (value == 0.0) {
      dx = thumbWidth / 2;
    } else if (value == 1.0 && parentBox != null) {
      dx = parentBox.size.width - thumbWidth / 2;
    }

    final rect = Rect.fromCenter(
      center: Offset(dx, center.dy),
      width: thumbWidth,
      height: thumbHeight,
    );

    canvas.drawRect(
      rect,
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
