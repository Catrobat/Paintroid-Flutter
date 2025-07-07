import 'dart:math';
import 'package:flutter/material.dart';
import 'package:colorpicker/src/components/color_wheel_painter.dart';
import 'package:colorpicker/src/constants/painter_thumb_constants.dart';

class ColorWheel extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorWheel({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<ColorWheel> createState() => _ColorWheelState();
}

class _ColorWheelState extends State<ColorWheel> {
  late Offset thumbPosition;
  double _currentRadius = 0.0;

  static const double _thumbDiameter = 24.0;
  static const double _thumbRadius = _thumbDiameter / 2;

  @override
  void initState() {
    super.initState();
    thumbPosition = Offset.zero;
  }

  void _initializeThumbPosition(double radius) {
    if ((_currentRadius - radius).abs() < 0.01 &&
        thumbPosition != Offset.zero &&
        _currentRadius != 0.0) {
      return;
    }

    _currentRadius = radius;
    final hsv = HSVColor.fromColor(widget.pickerColor);
    final angle = hsv.hue * pi / 180;
    final distance = (hsv.saturation * radius).clamp(0.0, radius);

    if (mounted) {
      setState(() {
        thumbPosition = Offset(
          radius + distance * cos(angle),
          radius + distance * sin(angle),
        );
      });
    }
  }

  void _updateColorFromPosition(Offset localPosition, double radius) {
    final center = Offset(radius, radius);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final rawDistance = sqrt(dx * dx + dy * dy);

    final distance = rawDistance.clamp(0.0, radius);

    final angle = atan2(dy, dx);
    final hue = (angle * 180 / pi + 360) % 360;

    final saturation = (distance / radius).clamp(0.0, 1.0);

    final newColor = HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor();

    setState(() {
      if (rawDistance > radius) {
        thumbPosition = Offset(
            center.dx + radius * cos(angle), center.dy + radius * sin(angle));
      } else {
        thumbPosition = localPosition;
      }
    });

    widget.onColorChanged(newColor);
  }

  @override
  void didUpdateWidget(covariant ColorWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pickerColor != oldWidget.pickerColor && _currentRadius > 0) {
      final hsv = HSVColor.fromColor(widget.pickerColor);
      final angle = hsv.hue * pi / 180;
      final distance =
          (hsv.saturation * _currentRadius).clamp(0.0, _currentRadius);
      final expectedPosition = Offset(
        _currentRadius + distance * cos(angle),
        _currentRadius + distance * sin(angle),
      );

      if ((thumbPosition - expectedPosition).distanceSquared > 1.0) {
        _initializeThumbPosition(_currentRadius);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double radius =
            min(constraints.maxWidth, constraints.maxHeight) * 0.5;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _initializeThumbPosition(radius);
          }
        });

        if (radius <= 0) {
          return const SizedBox.shrink();
        }

        return Center(
          child: SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: GestureDetector(
              onTapDown: (details) =>
                  _updateColorFromPosition(details.localPosition, radius),
              onPanStart: (details) =>
                  _updateColorFromPosition(details.localPosition, radius),
              onPanUpdate: (details) =>
                  _updateColorFromPosition(details.localPosition, radius),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(radius * 2, radius * 2),
                    painter: ColorWheelPainter(radius: radius),
                  ),
                  Positioned(
                    left: thumbPosition.dx - _thumbRadius,
                    top: thumbPosition.dy - _thumbRadius,
                    child: Container(
                      width: _thumbDiameter,
                      height: _thumbDiameter,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kColorWheelThumbStrokeColor,
                          width: kColorWheelThumbStrokeWidth,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
