import 'package:colorpicker/src/components/slider_indicator.dart';
import 'package:colorpicker/src/state/slider_state.dart';
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
    final positon = ref.watch(positionNotifierProvider);
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
      child: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) {},
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          double position = details.localPosition.dx;
          ref
              .read(positionNotifierProvider.notifier)
              .updatePosition(position, widgetWidth);
        },
        onHorizontalDragEnd: (DragEndDetails details) {},
        onTapDown: (TapDownDetails details) {
          double position = details.localPosition.dx;
          ref
              .read(positionNotifierProvider.notifier)
              .updatePosition(position, widgetWidth);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.gradientColor,
                widget.gradientColor.withOpacity(0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: CustomPaint(
            painter: SliderIndicatorPainter(positon),
          ),
        ),
      ),
    );
  }
}
