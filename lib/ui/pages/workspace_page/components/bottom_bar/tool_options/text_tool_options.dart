import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_provider.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class TextToolOptions extends ConsumerWidget {
  const TextToolOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(toolBoxStateProvider);
    return Column(
      children: [
        TextField(
          style: PaintroidTheme.of(context).textTheme.bodyMedium,
          onChanged: (newText) {
            ref.read(textToolProvider.notifier).updateText(newText);
          },
          decoration: InputDecoration(
            hintText: 'Enter text here',
            hintStyle: PaintroidTheme.of(context).textTheme.bodyMedium,
            filled: true,
            fillColor:
                PaintroidTheme.of(context).onSurfaceColor.withOpacity(0.3),
            contentPadding: const EdgeInsets.all(8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: PaintroidTheme.of(context).primaryColor,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: PaintroidTheme.of(context).primaryColor,
                width: 1.0,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
