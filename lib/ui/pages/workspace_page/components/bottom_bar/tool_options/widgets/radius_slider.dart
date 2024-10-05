import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/implementation/spray_tool.dart';
import 'package:paintroid/ui/theme/theme.dart';

class RadiusSlider extends ConsumerStatefulWidget {
  const RadiusSlider({super.key});

  @override
  ConsumerState<RadiusSlider> createState() => _RadiusSliderState();
}

class _RadiusSliderState extends ConsumerState<RadiusSlider> {
  late final TextEditingController _radiusTextController;
  double _radius = 20;

  void _onChangedTextField(String value) {
    final newRadius = int.tryParse(value) ?? 1;
    setState(() {
      _radius = newRadius.toDouble();
      _radiusTextController.text = newRadius.toString();
    });
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is SprayTool) {
      currentTool.updateSprayRadius(_radius);
    }
  }

  void _onChangedSlider(double newValue) {
    setState(() {
      _radius = newValue;
      _radiusTextController.text = newValue.toInt().toString();
    });
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is SprayTool) {
      currentTool.updateSprayRadius(_radius);
    }
  }

  @override
  void initState() {
    super.initState();
    final currentTool = ref.read(toolBoxStateProvider).currentTool;
    if (currentTool is SprayTool) {
      _radius = currentTool.sprayRadius;
    }
    _radiusTextController = TextEditingController(
      text: _radius.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _radiusTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: _radiusTextController,
              style: PaintroidTheme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^(100|[1-9][0-9]?)$'),
                  replacementString: _radius.toInt().toString(),
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
                value: _radius,
                min: 1,
                max: 100,
                divisions: 99,
                label: _radius.toInt().toString(),
                onChanged: _onChangedSlider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
