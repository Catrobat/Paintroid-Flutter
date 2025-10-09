import 'package:colorpicker/src/components/advanced_picker_widget.dart';
import 'package:colorpicker/src/components/grid_picker_widget.dart';
import 'package:colorpicker/src/components/hsv_rgb_sliders_picker_widget.dart';
import 'package:colorpicker/src/enums/main_picker_mode_type.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickerContentWidget extends ConsumerWidget {
  final MainPickerMode mainPickerMode;
  final Color colorForPickers;
  final void Function(Color) onColorChanged;
  final void Function(Color) onColorAndOpacityChanged;

  const PickerContentWidget({
    super.key,
    required this.mainPickerMode,
    required this.colorForPickers,
    required this.onColorChanged,
    required this.onColorAndOpacityChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGlobalOpacity = ref
        .read(colorPickerStateProvider.select((state) => state.currentOpacity));
    final colorForHsvRgbWithOpacity =
        colorForPickers.withAlpha((currentGlobalOpacity * 255).round());

    switch (mainPickerMode) {
      case MainPickerMode.grid:
        return GridPickerWidget(onColorSelected: onColorChanged);
      case MainPickerMode.advanced:
        return AdvancedPickerWidget(
            colorForPickers: colorForPickers,
            onColorChanged: onColorChanged,
            text1: 'Picker',
            text2: 'Wheel');
      case MainPickerMode.sliders:
        return HsvRgbSlidersPickerWidget(
            initialColor: colorForHsvRgbWithOpacity,
            onColorChanged: onColorAndOpacityChanged);
    }
  }
}
