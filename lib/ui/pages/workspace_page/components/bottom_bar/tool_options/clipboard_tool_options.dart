import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/clipboard_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ClipboardToolOptions extends ConsumerWidget {
  const ClipboardToolOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clipboardOptionsState = ref.watch(clipboardToolOptionsStateProvider);
    final clipboardOptionsNotifier =
        ref.read(clipboardToolOptionsStateProvider.notifier);

    final canvasImage =
        ref.watch(canvasStateProvider.select((s) => s.cachedImage));
    final paint = ref.watch(paintProvider);
    final shadowColor = PaintroidTheme.of(context).shadowColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CustomActionChip(
                chipIcon: ChipContent(
                    iconColor: shadowColor,
                    icon: Icons.copy,
                    text: 'Copy'
                ),
                hint: 'Copy selection',
                chipBackgroundColor: PaintroidTheme.of(context).onSurfaceColor,
                onPressed: () async {
                  if (canvasImage != null) {
                    await clipboardOptionsNotifier.performCopy(canvasImage);
                  }
                },
              ),
              const SizedBox(width: 4),
              CustomActionChip(
                chipIcon: ChipContent(
                    iconColor: shadowColor,
                    icon: Icons.content_cut,
                    text: 'Cut'
                ),
                hint: 'Cut selection',
                chipBackgroundColor: Colors.white,
                onPressed: () async {
                  if (canvasImage != null) {
                    await clipboardOptionsNotifier.performCut(canvasImage);
                  }
                },
              ),
              const SizedBox(width: 4),
              CustomActionChip(
                chipIcon: ChipContent(
                    iconColor: shadowColor,
                    icon: Icons.paste,
                    text: 'Paste'
                ),
                hint: 'Paste clipboard',
                chipBackgroundColor: Colors.white,
                onPressed: clipboardOptionsState.hasCopiedContent
                    ? () async {
                        await clipboardOptionsNotifier.performPaste(paint);
                      }
                    : null,
              ),
              const SizedBox(width: 4),
              CustomActionChip(
                chipIcon:ChipContent(
                    iconColor: shadowColor,
                    icon: Icons.cleaning_services_rounded,
                    text: 'Clear'
                ),
                hint: 'Clear clipboard',
                chipBackgroundColor: PaintroidTheme.of(context).onSurfaceColor,
                onPressed: clipboardOptionsState.hasCopiedContent
                    ? () async {
                        clipboardOptionsNotifier.clearClipboard();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChipContent extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String text;

  const ChipContent({
    super.key,
    required this.iconColor,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: iconColor
          ),
        ),
      ],
    );
  }
}
