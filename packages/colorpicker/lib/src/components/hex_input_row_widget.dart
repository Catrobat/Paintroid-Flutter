import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:colorpicker/src/utils/upper_case_text_formatter.dart';
import 'package:colorpicker/src/utils/hex_input_formatter.dart';

class HexInputRowWidget extends StatelessWidget {
  const HexInputRowWidget({
    super.key,
    required this.hexController,
    required this.hexFocusNode,
    required this.onSubmitted,
    required this.onEditingComplete,
  });

  final TextEditingController hexController;
  final FocusNode hexFocusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(
            width: 55,
            child: Text('HEX', style: TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: TextField(
              controller: hexController,
              focusNode: hexFocusNode,
              maxLength: 9,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                counterText: '',
              ),
              inputFormatters: [
                UpperCaseTextFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F#]')),
                HexInputFormatter(),
              ],
              onSubmitted: onSubmitted,
              onEditingComplete: onEditingComplete,
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }
}
