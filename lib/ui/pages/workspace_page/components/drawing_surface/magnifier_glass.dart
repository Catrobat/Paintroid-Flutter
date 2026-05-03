import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/ui/theme/theme.dart';

class MagnifierGlass extends ConsumerWidget {
  final ValueNotifier<Offset> focalPointNotifier;
  final Widget child;

  const MagnifierGlass({
    super.key,
    required this.focalPointNotifier,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentToolType = ref.watch(toolBoxStateProvider).currentTool.type;
    final isDown = ref.watch(toolBoxStateProvider).isDown;

    if (currentToolType != ToolType.PIPETTE || !isDown) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        const double magnifierSize = 100.0;
        const double margin = 20.0;
        const double topOffset = 40.0;

        return Stack(
          children: [
            child,
            ValueListenableBuilder<Offset>(
              valueListenable: focalPointNotifier,
              builder: (context, focalPoint, _) {
                final bool isLeft = focalPoint.dx < width / 2;

                final double leftPos =
                    isLeft ? width - margin - magnifierSize : margin;
                final double topPos = topOffset;

                final Offset magnifierCenter = Offset(
                  leftPos + magnifierSize / 2,
                  topPos + magnifierSize / 2,
                );

                final Offset focalPointOffset = focalPoint - magnifierCenter;

                return Positioned(
                  left: leftPos,
                  top: topPos,
                  child: RawMagnifier(
                    key: ValueKey(focalPointOffset),
                    decoration: MagnifierDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: CustomColors.oceanBlue,
                          width: 3,
                        ),
                      ),
                    ),
                    size: const Size(magnifierSize, magnifierSize),
                    magnificationScale: 1.5,
                    focalPointOffset: focalPointOffset,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
