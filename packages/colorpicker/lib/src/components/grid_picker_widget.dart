import 'package:flutter/material.dart';
import 'package:colorpicker/src/constants/colors.dart';
import 'package:colorpicker/src/components/checkerboard_square.dart';

class GridPickerWidget extends StatelessWidget {
  final void Function(Color) onColorSelected;

  const GridPickerWidget({super.key, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    const List<Color> colors = DisplayColors.colors;
    final theme = Theme.of(context);

    return GridView.builder(
      key: const ValueKey('grid_picker'),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: colors.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        if (index == colors.length) {
          return GestureDetector(
            onTap: () => onColorSelected(Colors.transparent),
            child: const CheckerboardSquare(),
          );
        }
        final color = colors[index];
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: theme.dividerColor, width: 1.0),
            ),
          ),
        );
      },
    );
  }
}
