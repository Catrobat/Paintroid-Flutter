import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorpicker/src/constants/colorpicker_colors.dart';
import 'package:logging/logging.dart';
import 'package:colorpicker/src/components/color_slider_row_widget.dart';
import 'package:colorpicker/src/components/hex_input_row_widget.dart';

final log = Logger('RgbSliderGroup');

class RgbSliderGroup extends ConsumerStatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const RgbSliderGroup({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  ConsumerState<RgbSliderGroup> createState() => _SliderColorState();
}

class _SliderColorState extends ConsumerState<RgbSliderGroup> {
  late int _red;
  late int _green;
  late int _blue;
  late int _alphaValue;
  late TextEditingController _hexController;
  late FocusNode _hexFocusNode;

  int _getAlpha(Color color) => (color.a * 255).round();

  int _getRed(Color color) => (color.r * 255).round();

  int _getGreen(Color color) => (color.g * 255).round();

  int _getBlue(Color color) => (color.b * 255).round();

  @override
  void initState() {
    super.initState();
    _hexController = TextEditingController();
    _hexFocusNode = FocusNode();
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
    _hexController.text = _colorToHex(color);
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
        !_hexFocusNode.hasFocus &&
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
        ColorSliderRowWidget(
          label: 'Red',
          value: _red.toDouble(),
          min: 0,
          max: 255,
          onChanged: (value) {
            if (_red != value.round()) {
              if (mounted) {
                setState(() {
                  _red = value.round();
                });
              }
              _updateColorFromSliders();
            }
          },
          sliderActiveColor: Colors.red,
        ),
        const SizedBox(height: 10),
        ColorSliderRowWidget(
          label: 'Green',
          value: _green.toDouble(),
          min: 0,
          max: 255,
          onChanged: (value) {
            if (_green != value.round()) {
              if (mounted) {
                setState(() {
                  _green = value.round();
                });
              }
              _updateColorFromSliders();
            }
          },
          sliderActiveColor: Colors.green,
        ),
        const SizedBox(height: 10),
        ColorSliderRowWidget(
          label: 'Blue',
          value: _blue.toDouble(),
          min: 0,
          max: 255,
          onChanged: (value) {
            if (_blue != value.round()) {
              if (mounted) {
                setState(() {
                  _blue = value.round();
                });
              }
              _updateColorFromSliders();
            }
          },
          sliderActiveColor: Colors.blue,
        ),
        const SizedBox(height: 10),
        ColorSliderRowWidget(
          label: 'Alpha',
          value: _alphaValue.toDouble(),
          min: 0,
          max: 255,
          onChanged: (value) {
            if (_alphaValue != value.round()) {
              if (mounted) {
                setState(() {
                  _alphaValue = value.round();
                });
              }
              _updateColorFromSliders();
            }
          },
          sliderActiveColor: ColorPickerColors.oceanBlue,
          isAlpha: true,
        ),
        const SizedBox(height: 16.0),
        HexInputRowWidget(
          hexController: _hexController,
          hexFocusNode: _hexFocusNode,
          onSubmitted: _updateColorFromHex,
          onEditingComplete: () {
            _updateColorFromHex(_hexController.text);
            if (mounted) _hexFocusNode.unfocus();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    _hexFocusNode.dispose();
    super.dispose();
  }
}
