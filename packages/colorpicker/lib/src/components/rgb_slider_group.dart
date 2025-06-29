import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/theme/data/custom_colors.dart';
import 'package:logging/logging.dart';
import 'package:colorpicker/src/utils/upper_case_text_formatter.dart';
import 'package:colorpicker/src/utils/hex_input_formatter.dart';

final log = Logger('RgbSliderGroup');

class RgbSliderGroup extends ConsumerStatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const RgbSliderGroup({
    Key? key,
    required this.initialColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  ConsumerState<RgbSliderGroup> createState() => _SliderColorState();
}

class _SliderColorState extends ConsumerState<RgbSliderGroup> {
  late int _red;
  late int _green;
  late int _blue;
  late int _alphaValue;
  late TextEditingController _hexController;

  int _getAlpha(Color color) => (color.a * 255).round();

  int _getRed(Color color) => (color.r * 255).round();

  int _getGreen(Color color) => (color.g * 255).round();

  int _getBlue(Color color) => (color.b * 255).round();

  @override
  void initState() {
    super.initState();
    _initializeStateFromColor(widget.initialColor);
  }

  @override
  void didUpdateWidget(RgbSliderGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      _initializeStateFromColor(widget.initialColor);
    }
  }

  void _initializeStateFromColor(Color color) {
    _red = _getRed(color);
    _green = _getGreen(color);
    _blue = _getBlue(color);
    _alphaValue = _getAlpha(color);
    _hexController = TextEditingController(text: _colorToHex(color));
  }

  String _colorToHex(Color color) {
    return '#${_getAlpha(color).toRadixString(16).padLeft(2, '0')}${_getRed(color).toRadixString(16).padLeft(2, '0')}${_getGreen(color).toRadixString(16).padLeft(2, '0')}${_getBlue(color).toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  Color? _tryParseHex(String hexString) {
    String hex = hexString.toUpperCase().replaceFirst('#', '');
    if (hex.length == 3) {
      hex = 'FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    }
    if (hex.length == 4) {
      String a = hex[0] + hex[0];
      String r = hex[1] + hex[1];
      String g = hex[2] + hex[2];
      String b = hex[3] + hex[3];
      hex = a + r + g + b;
    }
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length == 8) {
      try {
        return Color(int.parse(hex, radix: 16));
      } catch (e, stackTrace) {
        log.warning('Failed to parse hex string: $hexString', e, stackTrace);
      }
    }
    return null;
  }

  void _updateColorFromSliders() {
    final newColor = Color.fromARGB(_alphaValue, _red, _green, _blue);
    final newHex = _colorToHex(newColor);
    if (mounted &&
        !FocusScope.of(context).hasFocus &&
        _hexController.text.toUpperCase() != newHex.toUpperCase()) {
      _hexController.text = newHex;
    }
    widget.onColorChanged(newColor);
  }

  void _updateColorFromHex(String hexValue) {
    final Color? newColor = _tryParseHex(hexValue);
    if (newColor != null) {
      bool needsSetState = false;
      if (_red != _getRed(newColor)) {
        _red = _getRed(newColor);
        needsSetState = true;
      }
      if (_green != _getGreen(newColor)) {
        _green = _getGreen(newColor);
        needsSetState = true;
      }
      if (_blue != _getBlue(newColor)) {
        _blue = _getBlue(newColor);
        needsSetState = true;
      }
      if (_alphaValue != _getAlpha(newColor)) {
        _alphaValue = _getAlpha(newColor);
        needsSetState = true;
      }

      if (mounted && needsSetState) {
        setState(() {});
      }
      widget.onColorChanged(newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildSliderRow('Red', _red.toDouble(), 0, 255, (value) {
          if (_red != value.round()) {
            if (mounted) {
              setState(() {
                _red = value.round();
              });
            }
            _updateColorFromSliders();
          }
        }, Colors.red),
        const SizedBox(height: 10),
        _buildSliderRow('Green', _green.toDouble(), 0, 255, (value) {
          if (_green != value.round()) {
            if (mounted) {
              setState(() {
                _green = value.round();
              });
            }
            _updateColorFromSliders();
          }
        }, Colors.green),
        const SizedBox(height: 10),
        _buildSliderRow('Blue', _blue.toDouble(), 0, 255, (value) {
          if (_blue != value.round()) {
            if (mounted) {
              setState(() {
                _blue = value.round();
              });
            }
            _updateColorFromSliders();
          }
        }, Colors.blue),
        const SizedBox(height: 10),
        _buildSliderRow('Alpha', _alphaValue.toDouble(), 0, 255, (value) {
          if (_alphaValue != value.round()) {
            if (mounted) {
              setState(() {
                _alphaValue = value.round();
              });
            }
            _updateColorFromSliders();
          }
        }, CustomColors.oceanBlue, isAlpha: true),
        const SizedBox(height: 16),
        _buildHexInputRow(),
      ],
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max,
      ValueChanged<double> onChanged, Color sliderActiveColor,
      {bool isAlpha = false}) {
    final clampedValue = value.clamp(min, max);
    final String displayValue = isAlpha && max == 255
        ? '${(clampedValue / 255 * 100).round()}%'
        : clampedValue.round().toString();

    return Row(
      children: <Widget>[
        SizedBox(
          width: 55,
          child: Text(label,
              style: TextStyle(
                fontSize: 14,
                color: isAlpha ? CustomColors.oceanBlue : sliderActiveColor,
              )),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor:
                  sliderActiveColor.withAlpha((255 * 0.7).round()),
              inactiveTrackColor:
                  sliderActiveColor.withAlpha((255 * 0.3).round()),
              thumbColor: sliderActiveColor,
              overlayColor: sliderActiveColor.withAlpha(0x29),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: Slider(
              value: clampedValue,
              min: min,
              max: max,
              divisions: (max - min).round(),
              label: displayValue,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 45,
          child: Text(displayValue,
              textAlign: TextAlign.right,
              style:
                  const TextStyle(fontSize: 14, color: CustomColors.oceanBlue)),
        ),
      ],
    );
  }

  Widget _buildHexInputRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(
            width: 55,
            child: Text('HEX',
                style: TextStyle(fontSize: 14, color: Colors.black)),
          ),
          Expanded(
            child: TextField(
              controller: _hexController,
              maxLength: 9,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                focusColor: CustomColors.oceanBlue,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.oceanBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.oceanBlue),
                ),
                counterText: '',
              ),
              inputFormatters: [
                UpperCaseTextFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F#]')),
                HexInputFormatter(),
              ],
              onSubmitted: _updateColorFromHex,
              onEditingComplete: () {
                _updateColorFromHex(_hexController.text);
                if (mounted) FocusScope.of(context).unfocus();
              },
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }
}
