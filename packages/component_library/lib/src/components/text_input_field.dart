import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  const TextInputField({
    Key? key,
    required this.controller,
    this.hintText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? '',
        hintStyle: TextThemes.hintTextNormal,
        filled: true,
        fillColor: lightColorScheme.secondaryContainer,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      validator: validator,
    );
  }
}
