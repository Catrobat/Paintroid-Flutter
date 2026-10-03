import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacySerializableTypeface {
  final String font;
  final bool bold;
  final bool underline;
  final bool italic;
  final double textSize;
  final double textSkewX;

  LegacySerializableTypeface({
    required this.font,
    required this.bold,
    required this.underline,
    required this.italic,
    required this.textSize,
    required this.textSkewX,
  });

  factory LegacySerializableTypeface.deserialize(KryoReader reader) {
    final font = reader.readString() ?? 'SANS_SERIF';
    final bold = reader.readBoolean();
    final underline = reader.readBoolean();
    final italic = reader.readBoolean();
    final textSize = reader.readFloat();
    final textSkewX = reader.readFloat();
    return LegacySerializableTypeface(
      font: font,
      bold: bold,
      underline: underline,
      italic: italic,
      textSize: textSize,
      textSkewX: textSkewX,
    );
  }

  Map<String, dynamic> toJson() => {
    'font': font,
    'bold': bold,
    'underline': underline,
    'italic': italic,
    'textSize': textSize,
    'textSkewX': textSkewX,
  };
}
