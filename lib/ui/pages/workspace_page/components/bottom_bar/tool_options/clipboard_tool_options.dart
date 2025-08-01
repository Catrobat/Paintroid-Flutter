import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/clipboard_tool_options_state_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/ui/shared/custom_action_chip.dart';
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

    return Column(
      children: [
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomActionChip(
              chipIcon: const Icon(Icons.copy),
              hint: 'Copy selection',
              chipBackgroundColor: Colors.blue.shade100,
              onPressed: () async {
                if (canvasImage != null) {
                  await clipboardOptionsNotifier.performCopy(canvasImage);
                }
              },
            ),
            const SizedBox(width: 16),
            CustomActionChip(
              chipIcon: const Icon(Icons.content_cut),
              hint: 'Cut selection',
              chipBackgroundColor: Colors.orange.shade100,
              onPressed: () async {
                if (canvasImage != null) {
                  await clipboardOptionsNotifier.performCut(canvasImage);
                }
              },
            ),
            const SizedBox(width: 16),
            CustomActionChip(
                chipIcon: const Icon(Icons.paste),
                hint: 'Paste clipboard',
                chipBackgroundColor: Colors.green.shade100,
                onPressed: clipboardOptionsState.hasCopiedContent
                    ? () async {
                        await clipboardOptionsNotifier.performPaste(paint);
                      }
                    : () {
                        ToastUtils.showShortToast(message: 'Nothing to paste!');
                      }),
          ],
        )
      ],
    );
  }
}
