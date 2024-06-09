import 'package:colorpicker/pages/pipette_tool_page.dart';
import 'package:colorpicker/src/components/checkerboard_square.dart';
import 'package:colorpicker/src/components/color_square.dart';
import 'package:colorpicker/src/components/pipette_tool_button.dart';
import 'package:colorpicker/src/constants/colors.dart';
import 'package:colorpicker/src/components/color_comparison.dart';
import 'package:colorpicker/src/components/opacity_slider.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;

class ColorPicker extends ConsumerWidget {
  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
    required this.image,
  });

  final Color currentColor;
  final void Function(Color) onColorChanged;
  final ui.Image? image;

  final colors = DisplayColors.colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColorComparison(
                  currentColor: currentColor,
                  newColor: colorPickerStateData.currentColor != null
                      ? colorPickerStateData.currentColor!.withOpacity(
                          colorPickerStateData.currentOpacity,
                        )
                      : currentColor
                          .withOpacity(1.0)
                          .withOpacity(colorPickerStateData.currentOpacity),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PipetteToolPage(snapshot: image),
                      ),
                    );
                  },
                  child: const PipetteToolButton(),
                ),
              ],
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
                    return const Stack(children: [CheckerboardSquare()]);
                  } else {
                    return ColorSquare(color: colors[index]);
                  }
                },
              ),
            ),
            const SizedBox(height: 20.0),
            OpacitySlider(
              gradientColor: colorPickerStateData.currentColor != null
                  ? colorPickerStateData.currentColor!
                  : currentColor.withOpacity(1.0),
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
                    if (colorPickerStateData.currentColor != null) {
                      onColorChanged(colorPickerStateData.currentColor!
                          .withOpacity(colorPickerStateData.currentOpacity));
                    } else {
                      onColorChanged(currentColor
                          .withOpacity(1.0)
                          .withOpacity(colorPickerStateData.currentOpacity));
                    }
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
