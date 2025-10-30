import 'package:flutter/services.dart';

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
    } else if (filteredText.isEmpty &&
        oldValue.text.isNotEmpty &&
        text.isNotEmpty) {
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
