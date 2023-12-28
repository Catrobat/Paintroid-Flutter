import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:paintroid/ui/drawing_space/color_box.dart';

class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({
    required this.selectedColor,
    required this.onColorChanged,
    super.key,
  });

  final Color selectedColor;
  final Function(Color) onColorChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColorBox(color: Colors.black),
              ColorBox(color: Colors.green),
              ColorBox(color: Colors.red),
              ColorBox(color: Colors.blue),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            ),
            onPressed: () {
              ColorPicker(
                color: selectedColor,
                onColorChanged: onColorChanged,
              )
                  .showPickerDialog(
                    context,
                  )
                  .then((value) => Navigator.pop(context));
            },
            child: const Text('Open Color Picker'),
          ),
        ],
      ),
    );
  }
}
