import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class TextToolOptions extends ConsumerWidget {
  const TextToolOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          style: PaintroidTheme.of(context).textTheme.bodyMedium,
          onChanged: null,
          decoration: InputDecoration(
            hintText: 'Enter text here',
            hintStyle: PaintroidTheme.of(context).textTheme.bodyMedium,
            filled: true,
            fillColor: PaintroidTheme.of(context).onSurfaceColor,
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
      ],
    );
  }
}
