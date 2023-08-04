import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/src/brush_tool/brush_tool_state_provider.dart';
import 'package:paintroid/ui/styles.dart';

class TopBrushToolOptions extends ConsumerStatefulWidget {
  const TopBrushToolOptions({super.key});

  @override
  ConsumerState<TopBrushToolOptions> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends ConsumerState<TopBrushToolOptions> {
  late final TextEditingController _strokeWidthTextController;

  void _onChangedTextField(String value) {
    final newStrokeWidth = int.tryParse(value) ?? 1;
    ref
        .read(brushToolStateProvider.notifier)
        .updateStrokeWidth(newStrokeWidth.toDouble());
  }

  void _onChangedSlider(double newValue) {
    _strokeWidthTextController.text = newValue.toInt().toString();
    ref.read(brushToolStateProvider.notifier).updateStrokeWidth(newValue);
  }

  @override
  void initState() {
    super.initState();
    _strokeWidthTextController = TextEditingController(
      text:
          ref.read(brushToolStateProvider).paint.strokeWidth.toInt().toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _strokeWidthTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strokeWidth = ref.watch(brushToolStateProvider).paint.strokeWidth;

    return SizedBox(
      height: 25,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: _strokeWidthTextController,
              style: TextThemes.menuItem,
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
                fillColor: Colors.white,
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
