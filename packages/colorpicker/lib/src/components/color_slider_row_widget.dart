import 'package:flutter/material.dart';
import 'package:colorpicker/src/constants/colorpicker_colors.dart';

class ColorSliderRowWidget extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color sliderActiveColor;
  final bool isAlpha;

  const ColorSliderRowWidget({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.sliderActiveColor,
    this.isAlpha = false,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(min, max);
    final String displayValue = isAlpha && max == 255
        ? '${(clampedValue / 255 * 100).round()}%'
        : clampedValue.round().toString();

    return Row(
      children: <Widget>[
        SizedBox(
          width: 55,
          child: Text(label,
              style: TextStyle(
                fontSize: 14,
                color:
                    isAlpha ? ColorPickerColors.oceanBlue : sliderActiveColor,
              )),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor:
                  sliderActiveColor.withAlpha((255 * 0.7).round()),
              inactiveTrackColor:
                  sliderActiveColor.withAlpha((255 * 0.3).round()),
              thumbColor: sliderActiveColor,
              overlayColor: sliderActiveColor.withAlpha(0x29),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Slider(
              value: clampedValue,
              min: min,
              max: max,
              divisions: (max - min).round(),
              label: displayValue,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 45,
          child: Text(displayValue,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 14, color: ColorPickerColors.oceanBlue)),
        ),
      ],
    );
  }
}
