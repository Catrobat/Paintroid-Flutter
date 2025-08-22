// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextCommand _$TextCommandFromJson(Map<String, dynamic> json) => TextCommand(
      const OffsetConverter().fromJson(json['point'] as Map<String, dynamic>),
      json['text'] as String,
      const TextStyleConverter()
          .fromJson(json['style'] as Map<String, dynamic>),
      (json['fontSize'] as num).toDouble(),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      rotationAngle: (json['rotationAngle'] as num).toDouble(),
      scaleX: (json['scaleX'] as num?)?.toDouble() ?? 1.0,
      scaleY: (json['scaleY'] as num?)?.toDouble() ?? 1.0,
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.TEXT_COMMAND,
    );

Map<String, dynamic> _$TextCommandToJson(TextCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'point': const OffsetConverter().toJson(instance.point),
      'style': const TextStyleConverter().toJson(instance.style),
      'text': instance.text,
      'rotationAngle': instance.rotationAngle,
      'version': instance.version,
      'type': instance.type,
      'fontSize': instance.fontSize,
      'scaleX': instance.scaleX,
      'scaleY': instance.scaleY,
    };
