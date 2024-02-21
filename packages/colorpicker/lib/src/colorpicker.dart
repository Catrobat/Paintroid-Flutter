import 'package:colorpicker/src/constants/colors.dart';
import 'package:colorpicker/src/components/color_compare.dart';
import 'package:colorpicker/src/components/slider.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  final Color currentColor;
  final void Function(Color) onColorChanged;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final colors = DisplayColors.colors;
  Color newColor = Colors.black;
  double opacity = 1.0;

  void callback(Color color, double op) {
    setState(() {
      opacity = op;
    });
  }

  @override
  void initState() {
    super.initState();
    newColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(26.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ColorCompare(
            currentColor: widget.currentColor,
            newColor: newColor.withOpacity(opacity),
          ),
          const SizedBox(
            height: 10.0,
          ),
          GridView.count(
            childAspectRatio: 1.4,
            crossAxisCount: 4,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            shrinkWrap: true,
            children: List.generate(
              colors.length + 1,
              (index) {
                if (index == colors.length) {
                  return Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'packages/component_library/assets/img/checkerboard.png',
                        ),
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      newColor = colors[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[index],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          OpacitySlider(
            gradientColor: newColor,
            callback: callback,
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              const SizedBox(
                width: 10.0,
              ),
              TextButton(
                  onPressed: () {
                    widget.onColorChanged(newColor.withOpacity(opacity));
                    Navigator.pop(context);
                  },
                  child: const Text('APPLY')),
            ],
          )
        ],
      ),
    );
  }
}
