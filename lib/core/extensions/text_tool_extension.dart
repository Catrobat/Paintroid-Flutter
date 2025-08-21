import 'package:flutter/material.dart';

import 'package:paintroid/core/providers/state/text_tool_options_state_data.dart';

extension TextToolExtensions on TextToolOptionsStateData {
  TextStyle toTextStyle(Color color) => TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        decoration:
            isUnderline ? TextDecoration.underline : TextDecoration.none,
      );
}
