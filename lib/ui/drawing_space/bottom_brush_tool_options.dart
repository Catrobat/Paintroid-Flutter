import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/src/brush_tool/brush_tool_state_provider.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';

class BottomBrushToolOptions extends ConsumerStatefulWidget {
  const BottomBrushToolOptions({super.key});

  @override
  ConsumerState<BottomBrushToolOptions> createState() =>
      _BottomBrushToolOptionsState();
}

class _BottomBrushToolOptionsState
    extends ConsumerState<BottomBrushToolOptions> {
  Color _roundChipBackgroundColor = Colors.blue;
  Color _squareChipBackgroundColor = Colors.white;

  void _changeActionChipBackgroundColor(StrokeCap strokeCap) {
    _roundChipBackgroundColor =
        strokeCap == StrokeCap.round ? Colors.blue : Colors.white;
    _squareChipBackgroundColor =
        strokeCap == StrokeCap.square ? Colors.blue : Colors.white;
    ref.read(brushToolStateProvider.notifier).updateStrokeCap(strokeCap);
  }

  BorderRadius _getToolPreviewBorderRadius(
      StrokeCap strokeCap, double toolStrokeWidth) {
    if (strokeCap == StrokeCap.round) {
      return BorderRadius.horizontal(
        left: Radius.circular(toolStrokeWidth),
        right: Radius.circular(toolStrokeWidth),
      );
    } else {
      return const BorderRadius.horizontal();
    }
  }

  @override
  void initState() {
    super.initState();
    StrokeCap toolStrokeCapOnInit =
        ref.read(brushToolStateProvider).paint.strokeCap;
    _roundChipBackgroundColor =
        toolStrokeCapOnInit == StrokeCap.round ? Colors.blue : Colors.white;
    _squareChipBackgroundColor =
        toolStrokeCapOnInit == StrokeCap.square ? Colors.blue : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final currentPaint = ref.watch(brushToolStateProvider).paint;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          spacing: 8,
          children: [
            CustomActionChip(
              chipIcon: const Icon(Icons.circle),
              onPressed: () =>
                  _changeActionChipBackgroundColor(StrokeCap.round),
              chipBackgroundColor: _roundChipBackgroundColor,
            ),
            CustomActionChip(
              chipIcon: const Icon(Icons.square),
              onPressed: () =>
                  _changeActionChipBackgroundColor(StrokeCap.square),
              chipBackgroundColor: _squareChipBackgroundColor,
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: currentPaint.strokeWidth * 0.4,
          width: 130,
          decoration: BoxDecoration(
            color: currentPaint.color,
            borderRadius: _getToolPreviewBorderRadius(
              currentPaint.strokeCap,
              currentPaint.strokeWidth,
            ),
          ),
        ),
      ],
    );
  }
}
