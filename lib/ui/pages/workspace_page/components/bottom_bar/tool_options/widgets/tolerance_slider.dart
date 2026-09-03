import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/fill_tool.dart';
import 'package:paintroid/ui/theme/theme.dart';

class ToleranceSlider extends ConsumerStatefulWidget {
  const ToleranceSlider({super.key});

  @override
  ConsumerState<ToleranceSlider> createState() => _ToleranceSliderState();
}

class _ToleranceSliderState extends ConsumerState<ToleranceSlider> {
  late final TextEditingController _toleranceTextController;
  double _tolerance = 12;

  void _onChangedTextField(String value) {
    final newTolerance = int.tryParse(value) ?? 1;
    setState(() {
      _tolerance = newTolerance.toDouble();
      _toleranceTextController.text = newTolerance.toString();
    });
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is FillTool) {
      currentTool.updateTolerance(_tolerance);
    }
  }

  void _onChangedSlider(double newValue) {
    setState(() {
      _tolerance = newValue;
      _toleranceTextController.text = newValue.toInt().toString();
    });
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is FillTool) {
      currentTool.updateTolerance(_tolerance);
    }
  }

  @override
  void initState() {
    super.initState();
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is FillTool) {
      _tolerance = currentTool.tolerancePercent;
    }
    _toleranceTextController = TextEditingController(
      text: _tolerance.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _toleranceTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                showValueIndicator: ShowValueIndicator.never,
              ),
              child: Slider(
                value: _tolerance,
                min: 1,
                max: 100,
                divisions: 99,
                label: _tolerance.toInt().toString(),
                onChanged: _onChangedSlider,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: _toleranceTextController,
              style: PaintroidTheme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^(100|[1-9][0-9]?)$'),
                  replacementString: _tolerance.toInt().toString(),
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
        ],
      ),
    );
  }
}
