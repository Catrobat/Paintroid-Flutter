import 'package:colorpicker/src/constants/colors.dart';
import 'package:colorpicker/src/components/color_comparison.dart';
import 'package:colorpicker/src/components/slider.dart';
import 'package:colorpicker/src/state/color_state.dart';
import 'package:colorpicker/src/state/slider_position_state.dart';
import 'package:colorpicker/utils/assets.dart';
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
    final widgetWidth = MediaQuery.of(context).size.width - 52.0;
    final opacity = 1.0 - ref.watch(sliderPositionStateProvider) / widgetWidth;
    final newColor = ref.watch(colorStateProvider);
    return Container(
      margin: const EdgeInsets.all(26.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ColorComparison(
              currentColor: currentColor,
              newColor: newColor.withOpacity(opacity),
            ),
            const SizedBox(
              height: 10.0,
            ),
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
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: PackageAssets.getCheckerboardImgAsset(),
                          fit: BoxFit.contain,
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      ref.read(colorStateProvider.notifier).updateColor(
                            colors[index].withOpacity(opacity),
                          );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            OpacitySlider(
              gradientColor: newColor,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL'),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    onColorChanged(newColor.withOpacity(opacity));
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
