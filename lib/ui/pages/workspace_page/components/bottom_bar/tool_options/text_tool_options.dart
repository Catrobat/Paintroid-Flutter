import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/object/tools/text_tool_options_state_provider.dart';
import 'package:paintroid/ui/pages/landing_page/components/toggle_style_button.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class TextToolOptions extends ConsumerStatefulWidget {
  const TextToolOptions({super.key});

  @override
  ConsumerState<TextToolOptions> createState() => _TextToolOptionsState();
}

class _TextToolOptionsState extends ConsumerState<TextToolOptions> {
  late final TextEditingController _textController;
  late final TextEditingController _fontSizeController;

  @override
  void initState() {
    super.initState();
    final options = ref.read(textToolOptionsStateProvider);
    _textController = TextEditingController(text: options.text);
    _fontSizeController =
        TextEditingController(text: options.fontSize.toInt().toString());
  }

  @override
  void dispose() {
    _textController.dispose();
    _fontSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(textToolOptionsStateProvider);
    final notifier = ref.read(textToolOptionsStateProvider.notifier);

    if (_textController.text != options.text) {
      _textController.text = options.text;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: options.text.length),
      );
    }
    final fontSizeStr = options.fontSize.toInt().toString();
    if (_fontSizeController.text != fontSizeStr) {
      _fontSizeController.text = fontSizeStr;
      _fontSizeController.selection = TextSelection.fromPosition(
        TextPosition(offset: fontSizeStr.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 32,
                child: TextField(
                  key: const Key('text_tool_font_size'),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: _fontSizeController,
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
          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        selected: options.fontFamily == font,
                        onSelected: (_) => notifier.setFontFamily(font),
                        selectedColor: PaintroidTheme.of(context).primaryColor,
                        backgroundColor:
                            PaintroidTheme.of(context).onSurfaceColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 8),
          child: TextField(
            key: const Key('text_tool_input'),
            controller: _textController,
            onChanged: notifier.updateText,
            decoration: InputDecoration(
              hintText: 'Enter Text',
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
