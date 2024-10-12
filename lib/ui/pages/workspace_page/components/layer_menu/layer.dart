import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/layer_menu_state_provider.dart';
import 'package:paintroid/ui/theme/data/custom_colors.dart';

const layerHeight = 180.0;

class Layer extends ConsumerWidget {
  const Layer({
    super.key,
    this.isSelected = false,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(layerMenuStateProvider.notifier).toggleSelection(key);
      },
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: CustomColors.oceanBlue.withOpacity(isSelected ? 0.5 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: 0.5,
                        activeColor: Colors.grey,
                        inactiveColor: CustomColors.lightGray,
                        onChanged: (value) {},
                      ),
                    ),
                  )
                ],
              ),
            ),
            // const Spacer(),
            Container(
              width: 80,
              height: 180 - 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                key.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.drag_indicator_outlined),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
