import 'package:colorpicker/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:colorpicker/src/localization/colorpicker_localizations.dart';

class ColorComparison extends StatelessWidget {
  const ColorComparison({
    super.key,
    required this.currentColor,
    required this.newColor,
  });

  final Color currentColor;
  final Color newColor;

  @override
  Widget build(BuildContext context) {
    final localizations = ColorPickerLocalizations.of(context);
    return SizedBox(
      width: 130.0,
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            child: ColorDescription(
              color: currentColor,
              description: localizations.colorPickerCurrentColor,
            ),
          ),
          Expanded(
            child: ColorDescription(
              color: newColor,
              description: localizations.colorPickerNewColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ColorDescription extends StatelessWidget {
  const ColorDescription({
    super.key,
    required this.color,
    required this.description,
  });

  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: PackageAssets.getCheckerboardImgAsset(),
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          description,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
