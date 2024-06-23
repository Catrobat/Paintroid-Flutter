import 'package:colorpicker/src/components/slider_indicator_shape.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
// import 'package:colorpicker/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpacitySlider extends ConsumerWidget {
  const OpacitySlider({
    super.key,
    required this.gradientColor,
  });

  final Color gradientColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorPickerStateData = ref.watch(colorPickerStateProvider);
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'packages/colorpicker/assets/img/checkerboard.png',
            repeat: ImageRepeat.repeat,
            cacheHeight: 16,
            cacheWidth: 16,
            filterQuality: FilterQuality.none,
          ),
        ),
        SizedBox(
          height: 25.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradientColor.withOpacity(1.0),
                  gradientColor.withOpacity(0.0),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 25.0,
                trackShape: CustomTrackShape(),
                thumbShape: SliderIndicatorShape(),
                inactiveTrackColor: Colors.transparent,
                activeTrackColor: Colors.transparent,
                overlayColor: Colors.transparent,
              ),
              child: Slider(
                key: const Key('opacity_slider'),
                min: 0.0,
                max: 1.0,
                value: 1.0 - colorPickerStateData.currentOpacity,
                onChanged: (position) {
                  ref
                      .read(colorPickerStateProvider.notifier)
                      .updateOpacity(1.0 - position);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
