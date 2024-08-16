import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorSquare extends ConsumerWidget {
  const ColorSquare({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(colorPickerStateProvider.notifier).updateColor(color);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }
}
