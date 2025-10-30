import 'package:colorpicker/src/components/color_wheel.dart';
import 'package:colorpicker/src/components/hue_saturation_picker.dart';
import 'package:colorpicker/src/components/toggle_item_widget.dart';
import 'package:colorpicker/src/constants/colorpicker_colors.dart';
import 'package:colorpicker/src/enums/advanced_picker_mode_type.dart';
import 'package:flutter/material.dart';

class AdvancedPickerWidget extends StatefulWidget {
  final Color colorForPickers;
  final void Function(Color) onColorChanged;
  final String text1;
  final String text2;

  const AdvancedPickerWidget({
    super.key,
    required this.colorForPickers,
    required this.onColorChanged,
    required this.text1,
    required this.text2,
  });

  @override
  State<AdvancedPickerWidget> createState() =>
      _AdvancedPickerWidgetState();
}

class _AdvancedPickerWidgetState extends State<AdvancedPickerWidget> {
  AdvancedPickerMode _advancedPickerMode = AdvancedPickerMode.picker;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      key: const ValueKey('advanced_picker'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [
            _advancedPickerMode == AdvancedPickerMode.picker,
            _advancedPickerMode == AdvancedPickerMode.wheel,
          ],
          onPressed: (int index) {
            setState(() {
              _advancedPickerMode = index == 0
                  ? AdvancedPickerMode.picker
                  : AdvancedPickerMode.wheel;
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
                text: widget.text1,
                currentMode: _advancedPickerMode,
                buttonMode: AdvancedPickerMode.picker),
            ToggleItemWidget(
                text: widget.text2,
                currentMode: _advancedPickerMode,
                buttonMode: AdvancedPickerMode.wheel),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220.0,
          child: Center(
            child: _advancedPickerMode == AdvancedPickerMode.picker
                ? HueSaturationValuePicker(
                    initialColor: widget.colorForPickers,
                    onColorChanged: widget.onColorChanged)
                : ColorWheel(
                    pickerColor: widget.colorForPickers,
                    onColorChanged: widget.onColorChanged),
          ),
        ),
      ],
    );
  }
}
