import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/paint_provider.dart';
import 'package:paintroid/ui/theme/theme.dart';

class StrokeWidthSlider extends ConsumerStatefulWidget {
  const StrokeWidthSlider({super.key});

  @override
  ConsumerState<StrokeWidthSlider> createState() =>
      _StrokeWidthToolOptionState();
}

class _StrokeWidthToolOptionState extends ConsumerState<StrokeWidthSlider> {
  late final TextEditingController _strokeWidthTextController;

  void _onChangedTextField(String value) {
    final newStrokeWidth = int.tryParse(value) ?? 1;
    ref
        .read(paintProvider.notifier)
        .updateStrokeWidth(newStrokeWidth.toDouble());
  }

  void _onChangedSlider(double newValue) {
    _strokeWidthTextController.text = newValue.toInt().toString();
    ref.read(paintProvider.notifier).updateStrokeWidth(newValue);
  }

  @override
  void initState() {
    super.initState();
    _strokeWidthTextController = TextEditingController(
      text: ref.read(paintProvider).strokeWidth.toInt().toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _strokeWidthTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strokeWidth = ref.watch(paintProvider).strokeWidth;

    return SizedBox(
      height: 25,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: _strokeWidthTextController,
              style: PaintroidTheme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^(100|[1-9][0-9]?)$'),
                  replacementString: strokeWidth.toInt().toString(),
                ),
              ],
              onChanged: _onChangedTextField,
              decoration: InputDecoration(
                filled: true,
                fillColor: PaintroidTheme.of(context).onSurfaceColor,
                contentPadding: EdgeInsets.zero,
                hintText: '1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                showValueIndicator: ShowValueIndicator.never,
              ),
              child: Slider(
                value: strokeWidth,
                min: 1,
                max: 100,
                divisions: 100,
                label: strokeWidth.toInt().toString(),
                onChanged: _onChangedSlider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
