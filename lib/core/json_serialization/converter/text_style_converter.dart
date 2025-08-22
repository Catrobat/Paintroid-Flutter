import 'package:flutter/painting.dart';
import 'package:json_annotation/json_annotation.dart';

class TextStyleConverter
    implements JsonConverter<TextStyle, Map<String, dynamic>> {
  const TextStyleConverter();

  @override
  TextStyle fromJson(Map<String, dynamic> json) {
    return TextStyle(
      color: json['color'] != null ? Color(json['color'] as int) : null,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: _parseFontWeight(json['fontWeight'] as String?),
      fontStyle: _parseFontStyle(json['fontStyle'] as String?),
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble(),
      wordSpacing: (json['wordSpacing'] as num?)?.toDouble(),
      fontFamily: json['fontFamily'] as String?,
      decoration: _parseDecoration(json['decoration'] as String?),
    );
  }

  @override
  Map<String, dynamic> toJson(TextStyle style) {
    return {
      'color': style.color?.toARGB32(),
      'fontSize': style.fontSize,
      'fontWeight': _fontWeightToString(style.fontWeight),
      'fontStyle': _fontStyleToString(style.fontStyle),
      'letterSpacing': style.letterSpacing,
      'wordSpacing': style.wordSpacing,
      'fontFamily': style.fontFamily,
      'decoration': _decorationToString(style.decoration),
    };
  }

  FontWeight? _parseFontWeight(String? value) {
    switch (value) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return null;
    }
  }

  String? _fontWeightToString(FontWeight? weight) {
    if (weight == null) return null;
    return weight.toString().split('.').last;
  }

  FontStyle? _parseFontStyle(String? value) {
    switch (value) {
      case 'italic':
        return FontStyle.italic;
      case 'normal':
        return FontStyle.normal;
      default:
        return null;
    }
  }

  String? _fontStyleToString(FontStyle? style) {
    if (style == null) return null;
    return style.toString().split('.').last;
  }

  TextDecoration? _parseDecoration(String? value) {
    switch (value) {
      case 'underline':
        return TextDecoration.underline;
      case 'lineThrough':
        return TextDecoration.lineThrough;
      case 'overline':
        return TextDecoration.overline;
      case 'none':
        return TextDecoration.none;
      default:
        return null;
    }
  }

  String? _decorationToString(TextDecoration? decoration) {
    if (decoration == null) return null;
    return decoration.toString().split('.').last;
  }
}
