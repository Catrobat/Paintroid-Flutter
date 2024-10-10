import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/layer_menu_state_provider.dart';

List<Color> customColors = [
  const Color(0xFFFF5733), // Fiery Red
  const Color(0xFF33C1FF), // Sky Blue
  const Color(0xFF75FF33), // Lime Green
  const Color(0xFFFF33A8), // Hot Pink
  const Color(0xFF33FFF5), // Aqua
  const Color(0xFFFFD133), // Golden Yellow
  const Color(0xFF8D33FF), // Deep Purple
  const Color(0xFFFF8333), // Vibrant Orange
  const Color(0xFF33FF8D), // Mint Green
  const Color(0xFF3361FF), // Bright Indigo
];

class Layer extends ConsumerWidget {
  const Layer({
    super.key,
    this.isSelected = false,
    required this.id,
  });

  final int id;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(layerMenuStateProvider.notifier).toggleSelection(id);
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: customColors[id],
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Colors.blue,
                  width: 5.0,
                )
              : null,
        ),
      ),
    );
  }
}
