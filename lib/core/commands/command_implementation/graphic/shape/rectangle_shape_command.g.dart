// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle_shape_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RectangleShapeCommand _$RectangleShapeCommandFromJson(
        Map<String, dynamic> json) =>
    RectangleShapeCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      const OffsetConverter().fromJson(json['topLeft'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['topRight'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['bottomLeft'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['bottomRight'] as Map<String, dynamic>),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.RECTANGLE_SHAPE_COMMAND,
    );

Map<String, dynamic> _$RectangleShapeCommandToJson(
        RectangleShapeCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'topLeft': const OffsetConverter().toJson(instance.topLeft),
      'topRight': const OffsetConverter().toJson(instance.topRight),
      'bottomLeft': const OffsetConverter().toJson(instance.bottomLeft),
      'bottomRight': const OffsetConverter().toJson(instance.bottomRight),
      'version': instance.version,
      'type': instance.type,
    };
