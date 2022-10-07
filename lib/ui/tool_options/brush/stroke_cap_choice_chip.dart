import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/tool_options/brush/brush_options_state.dart';

class StrokeCapChoiceChip extends ConsumerWidget {
  const StrokeCapChoiceChip({Key? key, required this.icon, required this.cap})
      : super(key: key);

  final IconData icon;
  final StrokeCap cap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCap = ref.watch(
      BrushOptionsState.provider.select((value) => value.strokeCap),
    );
    return ChoiceChip(
      label: Icon(icon),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(width: 0.25),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      selectedColor: Theme.of(context).primaryColor,
      selected: cap == selectedCap,
      onSelected: (selected) {
        if (selected && selectedCap != cap) {
          ref
              .read(BrushOptionsState.provider.notifier)
              .onCapChanged(cap);
        }
      },
    );
  }
}
