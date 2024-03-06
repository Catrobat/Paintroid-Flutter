import 'package:colorpicker/src/components/slider_shape.dart';
import 'package:colorpicker/src/state/slider_position_state.dart';
import 'package:colorpicker/utils/assets.dart';
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
    final positon = ref.watch(sliderPositionStateProvider);
    double widgetWidth = MediaQuery.of(context).size.width - 52.0;
    return Container(
      height: 25.0,
      width: widgetWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: PackageAssets.getCheckerboardImgAsset(),
          fit: BoxFit.fitHeight,
          repeat: ImageRepeat.repeat,
        ),
      ),
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
            min: 0.0,
            max: 1.0,
            value: positon / widgetWidth,
            onChanged: (value) {
              ref.read(sliderPositionStateProvider.notifier).updatePosition(
                    value * widgetWidth,
                    widgetWidth,
                  );
            },
          ),
        ),
      ),
    );
  }
}
