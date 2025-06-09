import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class TextToolOptions extends ConsumerWidget {
  const TextToolOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(textToolOptionsStateProvider);
    final notifier = ref.read(textToolOptionsStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 32,
                child: TextField(
                  key: const Key('text_tool_font_size'),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: options.fontSize.toInt().toString())
                    ..selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: options.fontSize.toInt().toString().length),
                    ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null && parsed > 0) {
                      notifier.setAutoSize(false);
                      notifier.setFontSize(parsed);
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    filled: true,
                    fillColor: PaintroidTheme.of(context).onSurfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                          color: PaintroidTheme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ToggleStyleButton(
                label: 'U',
                selected: options.isUnderline,
                onTap: notifier.toggleUnderline,
              ),
              const SizedBox(width: 8),
              ToggleStyleButton(
                label: 'I',
                selected: options.isItalic,
                onTap: notifier.toggleItalic,
              ),
              const SizedBox(width: 8),
              ToggleStyleButton(
                label: 'B',
                selected: options.isBold,
                onTap: notifier.toggleBold,
              ),
            ],
          ),
        ),
        const Spacer(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              'Roboto',
              'Sans Serif',
              'Serif',
              'Monospace',
              'Open Sans',
              'Inter',
              'Wind',
              'Space Mono',
              'Work Sans'
            ]
                .map((font) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          font,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        selected: options.fontFamily == font,
                        onSelected: (_) => notifier.setFontFamily(font),
                        selectedColor: PaintroidTheme.of(context).primaryColor,
                        backgroundColor:
                            PaintroidTheme.of(context).onSurfaceColor,
                      ),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TextField(
            key: const Key('text_tool_input'),
            controller: TextEditingController(text: options.text)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: options.text.length),
              ),
            onChanged: notifier.updateText,
            decoration: InputDecoration(
              hintText: 'Tap here to write',
              filled: true,
              fillColor:
                  PaintroidTheme.of(context).onSurfaceColor.withAlpha(50),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}

class ToggleStyleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ToggleStyleButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? PaintroidTheme.of(context).primaryColor
          : PaintroidTheme.of(context).onSurfaceColor,
      shape:
          const CircleBorder(side: BorderSide(color: Colors.black, width: 1.0)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
