import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final log = Logger('hsv_slider');

class HsvSliderGroup extends ConsumerStatefulWidget {
  const HsvSliderGroup({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  final Color initialColor;
  final void Function(Color) onColorChanged;

  @override
  ConsumerState<HsvSliderGroup> createState() => _HsvSliderGroupState();
}

class _HsvSliderGroupState extends ConsumerState<HsvSliderGroup> {
  late HSVColor _hsvColor;
  late double _alpha;

  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.initialColor);
    _alpha = widget.initialColor.a;
  }

  @override
  void didUpdateWidget(covariant HsvSliderGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialColor != oldWidget.initialColor) {
      final newHsvColor = HSVColor.fromColor(widget.initialColor);
      final newAlpha = widget.initialColor.a;

      final hueEqual = (_hsvColor.hue - newHsvColor.hue).abs() < 0.01 ||
          (_hsvColor.hue - newHsvColor.hue).abs() > 359.99;

      final satEqual =
          (_hsvColor.saturation - newHsvColor.saturation).abs() < 0.001;
      final valEqual = (_hsvColor.value - newHsvColor.value).abs() < 0.001;
      final alphaEqual = (_alpha - newAlpha).abs() < 0.001;

      bool needsSetState = false;

      if (!hueEqual || !satEqual || !valEqual) {
        _hsvColor = newHsvColor;
        needsSetState = true;
      }

      if (!alphaEqual) {
        _alpha = newAlpha;
        needsSetState = true;
      }

      if (needsSetState) {
        setState(() {});
      }
    }
  }

  void _handleHueChanged(double hue) {
    setState(() {
      _hsvColor = _hsvColor.withHue(hue.clamp(0.0, 359.999));
    });
    widget.onColorChanged(_hsvColor.withAlpha(_alpha).toColor());
  }

  void _handleSaturationChanged(double saturation) {
    final newSaturation = saturation.clamp(0.0, 1.0);
    if ((_hsvColor.saturation - newSaturation).abs() < 0.001) return;

    setState(() {
      _hsvColor = _hsvColor.withSaturation(newSaturation);
    });
    widget.onColorChanged(_hsvColor.withAlpha(_alpha).toColor());
  }

  void _handleValueChanged(double value) {
    setState(() {
      _hsvColor = _hsvColor.withValue(value);
    });
    widget.onColorChanged(_hsvColor.withAlpha(_alpha).toColor());
  }

  void _handleAlphaChanged(double alpha) {
    setState(() {
      _alpha = alpha;
    });
    widget.onColorChanged(_hsvColor.withAlpha(_alpha).toColor());
  }

  @override
  Widget build(BuildContext context) {
    String hsvText = '(${_hsvColor.hue.round()}°, '
        '${(_hsvColor.saturation * 100).toStringAsFixed(0)}%, '
        '${(_hsvColor.value * 100).toStringAsFixed(0)}%)';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(hsvText,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            const SizedBox(
              width: 45,
              child: Text('Hue:'),
            ),
            Expanded(
              child: Slider(
                value: _hsvColor.hue,
                min: 0.0,
                max: 359.999,
                onChanged: _handleHueChanged,
              ),
            ),
            SizedBox(
              width: 45,
              child: Text(
                '${_hsvColor.hue.round()}°',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 45,
              child: Text('Sat:'),
            ),
            Expanded(
              child: Slider(
                value: _hsvColor.saturation,
                min: 0.0,
                max: 1.0,
                onChanged: _handleSaturationChanged,
              ),
            ),
            SizedBox(
              width: 55,
              child: Text(
                '${(_hsvColor.saturation * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 45,
              child: Text('Val:'),
            ),
            Expanded(
              child: Slider(
                value: _hsvColor.value,
                min: 0.0,
                max: 1.0,
                onChanged: _handleValueChanged,
              ),
            ),
            SizedBox(
              width: 55,
              child: Text(
                '${(_hsvColor.value * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 45,
              child: Text('Alpha:'),
            ),
            Expanded(
              child: Slider(
                value: _alpha,
                min: 0.0,
                max: 1.0,
                onChanged: _handleAlphaChanged,
              ),
            ),
            SizedBox(
              width: 55,
              child: Text(
                '${(_alpha * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
