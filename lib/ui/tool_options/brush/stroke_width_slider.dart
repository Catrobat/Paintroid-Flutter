import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/tool_options/brush/brush_options_state.dart';

class StrokeWidthSlider extends ConsumerWidget {
  const StrokeWidthSlider({Key? key}) : super(key: key);

  TextEditingValue _widthFormatter(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final num = int.parse(newValue.text);
    return num >= 1 && num <= 100 ? newValue : oldValue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: ref
                .watch(BrushOptionsState.provider.notifier)
                .widthTextController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              constraints: BoxConstraints(maxWidth: 55),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction(_widthFormatter),
            ],
            autocorrect: false,
            expands: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            onChanged: ref
                .watch(BrushOptionsState.provider.notifier)
                .onWidthTextChanged,
            onSubmitted: ref
                .watch(BrushOptionsState.provider.notifier)
                .onWidthTextSubmitted,
          ),
          Expanded(
            child: Slider(
              value: ref.watch(
                BrushOptionsState.provider.select((state) => state.strokeWidth),
              ),
              min: 1,
              max: 100,
              divisions: 100,
              onChanged: ref
                  .watch(BrushOptionsState.provider.notifier)
                  .onWidthSliderChanged,
            ),
          )
        ],
      ),
    );
  }
}
