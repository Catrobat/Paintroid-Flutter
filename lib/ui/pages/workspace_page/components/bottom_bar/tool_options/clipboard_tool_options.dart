import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/clipboard_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';
import 'package:paintroid/ui/utils/toast_utils.dart';

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
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomActionChip(
              chipIcon: Icon(Icons.copy, color: shadowColor),
              hint: 'Copy selection',
              chipBackgroundColor: Colors.white,
              onPressed: () async {
                if (canvasImage != null) {
                  await clipboardOptionsNotifier.performCopy(canvasImage);
                }
              },
            ),
            const SizedBox(width: 16),
            CustomActionChip(
              chipIcon: Icon(Icons.content_cut, color: shadowColor),
              hint: 'Cut selection',
              chipBackgroundColor: Colors.white,
              onPressed: () async {
                if (canvasImage != null) {
                  await clipboardOptionsNotifier.performCut(canvasImage);
                }
              },
            ),
            const SizedBox(width: 16),
            CustomActionChip(
              chipIcon: Icon(Icons.paste, color: shadowColor),
              hint: 'Paste clipboard',
              chipBackgroundColor: Colors.white,
              onPressed: clipboardOptionsState.hasCopiedContent
                  ? () async {
                      await clipboardOptionsNotifier.performPaste(paint);
                    }
                  : () {
                      ToastUtils.showShortToast(message: 'Nothing to paste!');
                    },
            ),
            const SizedBox(width: 16),
            CustomActionChip(
              chipIcon: Icon(Icons.delete_outline, color: shadowColor),
              hint: 'Clear clipboard',
              chipBackgroundColor: Colors.white,
              onPressed: clipboardOptionsState.hasCopiedContent
                  ? () {
                      clipboardOptionsNotifier.clearClipboard();
                      ToastUtils.showShortToast(message: 'Clipboard cleared');
                    }
                  : () {
                      ToastUtils.showShortToast(message: 'Nothing to clear!');
                    },
            )
          ],
        ),
      ],
    );
  }
}
