import 'package:colorpicker/src/components/slider_shape.dart';
import 'package:colorpicker/src/state/slider_position_state.dart';
import 'package:colorpicker/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpacitySlider extends ConsumerStatefulWidget {
  const OpacitySlider({
    super.key,
    required this.gradientColor,
  });

  final Color gradientColor;

  @override
  ConsumerState<OpacitySlider> createState() => _OpacitySliderState();
}

class _OpacitySliderState extends ConsumerState<OpacitySlider> {
  @override
  Widget build(BuildContext context) {
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
      // child: GestureDetector(
      //   onHorizontalDragStart: (DragStartDetails details) {},
      //   onHorizontalDragUpdate: (DragUpdateDetails details) {
      //     double position = details.localPosition.dx;
      //     ref
      //         .read(sliderPositionStateProvider.notifier)
      //         .updatePosition(position, widgetWidth);
      //   },
      //   onHorizontalDragEnd: (DragEndDetails details) {},
      //   onTapDown: (TapDownDetails details) {
      //     double position = details.localPosition.dx;
      //     ref
      //         .read(sliderPositionStateProvider.notifier)
      //         .updatePosition(position, widgetWidth);
      //   },
      //   child: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           widget.gradientColor.withOpacity(1.0),
      //           widget.gradientColor.withOpacity(0.0),
      //         ],
      //         begin: Alignment.centerLeft,
      //         end: Alignment.centerRight,
      //       ),
      //     ),
      //     child: CustomPaint(
      //       painter: SliderIndicatorPainter(positon),
      //     ),
      //   ),
      // ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.gradientColor.withOpacity(1.0),
              widget.gradientColor.withOpacity(0.0),
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
