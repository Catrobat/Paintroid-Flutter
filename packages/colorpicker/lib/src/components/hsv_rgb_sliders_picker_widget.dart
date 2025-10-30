import 'package:colorpicker/src/components/hsv_slider_group.dart';
import 'package:colorpicker/src/components/rgb_slider_group.dart';
import 'package:colorpicker/src/components/toggle_item_widget.dart';
import 'package:colorpicker/src/constants/colorpicker_colors.dart';
import 'package:colorpicker/src/enums/slider_picker_mode_type.dart';
import 'package:flutter/material.dart';

class HsvRgbSlidersPickerWidget extends StatefulWidget {
  final Color initialColor;
  final void Function(Color) onColorChanged;

  const HsvRgbSlidersPickerWidget({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<HsvRgbSlidersPickerWidget> createState() =>
      _HsvRgbSlidersPickerWidgetState();
}

class _HsvRgbSlidersPickerWidgetState extends State<HsvRgbSlidersPickerWidget> {
  SliderPickerMode _sliderTypeMode = SliderPickerMode.hsv;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      key: const ValueKey('slider_picker'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [
            _sliderTypeMode == SliderPickerMode.hsv,
            _sliderTypeMode == SliderPickerMode.rgb,
          ],
          onPressed: (int index) {
            setState(() {
              _sliderTypeMode =
                  index == 0 ? SliderPickerMode.hsv : SliderPickerMode.rgb;
            });
          },
          borderRadius: BorderRadius.circular(18.0),
          borderWidth: 1.5,
          borderColor: colorScheme.primary,
          selectedBorderColor: colorScheme.primary,
          fillColor: colorScheme.surface,
          color: ColorPickerColors.orange,
          constraints: const BoxConstraints(minHeight: 30.0, minWidth: 70.0),
          children: <Widget>[
            ToggleItemWidget(
                text: 'HSV',
                currentMode: _sliderTypeMode,
                buttonMode: SliderPickerMode.hsv),
            ToggleItemWidget(
                text: 'RGB',
                currentMode: _sliderTypeMode,
                buttonMode: SliderPickerMode.rgb),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _sliderTypeMode == SliderPickerMode.hsv
              ? HsvSliderGroup(
                  initialColor: widget.initialColor,
                  onColorChanged: widget.onColorChanged)
              : RgbSliderGroup(
                  initialColor: widget.initialColor,
                  onColorChanged: widget.onColorChanged),
        ),
      ],
    );
  }
}
