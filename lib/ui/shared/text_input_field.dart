// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  const TextInputField({
    super.key,
    required this.controller,
    this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? '',
        hintStyle: PaintroidTheme.of(context).hintStyle,
        filled: true,
        fillColor: PaintroidTheme.of(context).secondaryContainerColor,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      validator: validator,
    );
  }
}
