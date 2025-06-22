import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/theme/data/custom_colors.dart';
import 'package:logging/logging.dart';

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
  late double _alpha;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _initializeStateFromColor(widget.initialColor);
    _hexController =
        TextEditingController(text: _colorToHex(widget.initialColor));
  }

  @override
  void didUpdateWidget(RgbSliderGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      _initializeStateFromColor(widget.initialColor);
      final newHex = _colorToHex(widget.initialColor);
      if (_hexController.text.toUpperCase() != newHex.toUpperCase()) {
        _hexController.text = newHex;
      }
      setState(() {});
    }
  }

  void _initializeStateFromColor(Color color) {
    _red = color.r.toInt();
    _green = color.g.toInt();
    _blue = color.b.toInt();
    _alpha = color.a;
  }

  String _colorToHex(Color color) {
    return '#${color.a.toInt().toRadixString(16).padLeft(2, '0')}${color.r.toInt().toRadixString(16).padLeft(2, '0')}${color.g.toInt().toRadixString(16).padLeft(2, '0')}${color.b.toInt().toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  Color? _tryParseHex(String hexString) {
    String hex = hexString.toUpperCase().replaceFirst('#', '');
    if (hex.length == 3) {
      hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    }
    if (hex.length == 4) {
      String r = hex[0] + hex[0];
      String g = hex[1] + hex[1];
      String b = hex[2] + hex[2];
      String a = hex[3] + hex[3];
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
    final newColor =
        Color.fromARGB((_alpha * 255).round(), _red, _green, _blue);
    final newHex = _colorToHex(newColor);
    if (_hexController.text.toUpperCase() != newHex.toUpperCase()) {
      _hexController.text = newHex;
    }
    widget.onColorChanged(newColor);
  }

  void _updateColorFromHex(String hexValue) {
    final Color? newColor = _tryParseHex(hexValue);
    if (newColor != null) {
      bool needsSetState = false;
      if (_red != newColor.r.toInt()) {
        _red = newColor.r.toInt();
        needsSetState = true;
      }
      if (_green != newColor.g.toInt()) {
        _green = newColor.g.toInt();
        needsSetState = true;
      }
      if (_blue != newColor.b.toInt()) {
        _blue = newColor.b.toInt();
        needsSetState = true;
      }
      if ((_alpha - newColor.a).abs() > 0.001) {
        _alpha = newColor.a;
        needsSetState = true;
      }

      if (needsSetState) {
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
            setState(() {
              _red = value.round();
            });
            _updateColorFromSliders();
          }
        }, Colors.red),
        const SizedBox(height: 10),
        _buildSliderRow('Green', _green.toDouble(), 0, 255, (value) {
          if (_green != value.round()) {
            setState(() {
              _green = value.round();
            });
            _updateColorFromSliders();
          }
        }, Colors.green),
        const SizedBox(height: 10),
        _buildSliderRow('Blue', _blue.toDouble(), 0, 255, (value) {
          if (_blue != value.round()) {
            setState(() {
              _blue = value.round();
            });
            _updateColorFromSliders();
          }
        }, Colors.blue),
        const SizedBox(height: 10),
        _buildSliderRow('Alpha', _alpha * 100, 0, 100, (value) {
          final newAlpha = value / 100;
          if ((_alpha - newAlpha).abs() > 0.001) {
            setState(() {
              _alpha = newAlpha;
            });
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
              divisions: isAlpha ? 100 : 255,
              label: isAlpha
                  ? '${clampedValue.round()}%'
                  : clampedValue.round().toString(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 45,
          child: Text(
              isAlpha
                  ? '${clampedValue.round()}%'
                  : clampedValue.round().toString(),
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
                FocusScope.of(context).unfocus();
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class HexInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    String filteredText = text.replaceAll(RegExp(r'[^0-9A-Fa-f#]'), '');

    if (filteredText.isNotEmpty && filteredText[0] != '#') {
      filteredText = '#$filteredText';
    } else if (filteredText.length > 1 &&
        filteredText.substring(1).contains('#')) {
      filteredText = oldValue.text;
    } else if (filteredText.isEmpty && oldValue.text.isNotEmpty) {
      return TextEditingValue.empty;
    } else if (filteredText.isEmpty && text.isNotEmpty) {
      return oldValue;
    }

    if (filteredText.length > 9) {
      filteredText = filteredText.substring(0, 9);
    }

    if (filteredText != newValue.text) {
      return TextEditingValue(
        text: filteredText,
        selection: TextSelection.collapsed(offset: filteredText.length),
      );
    }
    return newValue;
  }
}
