import 'package:colorpicker/src/components/checkerboard_square.dart';
import 'package:colorpicker/src/components/color_square.dart';
import 'package:colorpicker/src/constants/colors.dart';
import 'package:colorpicker/src/components/color_comparison.dart';
import 'package:colorpicker/src/components/opacity_slider.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPicker extends ConsumerWidget {
  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  final Color currentColor;
  final void Function(Color) onColorChanged;

  final colors = DisplayColors.colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(Duration.zero, () {
      if (ref.read(colorPickerStateProvider).currentColor == null) {
        final data = ref.read(colorPickerStateProvider.notifier);
        data.updateColor(currentColor);
        data.updateOpacity(currentColor.opacity);
      }
    });
    final colorPickerStateData = ref.watch(colorPickerStateProvider);
    return Container(
      margin: const EdgeInsets.all(26.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ColorComparison(
              currentColor: currentColor,
              newColor: colorPickerStateData.currentColor!.withOpacity(
                colorPickerStateData.currentOpacity,
              ),
            ),
            const SizedBox(height: 10.0),
            GridView.count(
              childAspectRatio: 1.4,
              crossAxisCount: 4,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
              shrinkWrap: true,
              children: List.generate(
                colors.length + 1,
                (index) {
                  if (index == colors.length) {
                    return const CheckerboardSquare();
                  } else {
                    return ColorSquare(
                      color: colors[index],
                      opacity: colorPickerStateData.currentOpacity,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20.0),
            OpacitySlider(
              gradientColor: colorPickerStateData.currentColor!,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 10.0),
                TextButton(
                  onPressed: () {
                    onColorChanged(colorPickerStateData.currentColor!
                        .withOpacity(colorPickerStateData.currentOpacity));
                    Navigator.pop(context);
                  },
                  child: const Text('APPLY'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
