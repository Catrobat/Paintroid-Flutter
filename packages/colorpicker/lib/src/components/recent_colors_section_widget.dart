import 'package:colorpicker/src/state/recent_color_state_provider.dart';
import 'package:colorpicker/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentColorsSectionWidget extends ConsumerWidget {
  final void Function(Color) onColorSelected;

  const RecentColorsSectionWidget({super.key, required this.onColorSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentColors = ref.watch(recentColorsProvider);
    final theme = Theme.of(context);

    if (recentColors.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: recentColors.map((color) {
            final bool needsCheckerboard = color.a < 1.0;

            return GestureDetector(
              onTap: () {
                onColorSelected(color);
              },
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  image: needsCheckerboard
                      ? DecorationImage(
                          image: PackageAssets.getCheckerboardImgAsset(),
                          repeat: ImageRepeat.repeat,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: theme.dividerColor, width: 1.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'recently used',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color:
                  theme.textTheme.bodySmall?.color?.withAlpha((178.5).toInt()),
            ),
          ),
        ),
      ],
    );
  }
}
