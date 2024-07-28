// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_shape_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SquareShapeCommand _$SquareShapeCommandFromJson(Map<String, dynamic> json) =>
    SquareShapeCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      const OffsetConverter().fromJson(json['topLeft'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['topRight'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['bottomLeft'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['bottomRight'] as Map<String, dynamic>),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.SQUARE_SHAPE_COMMAND,
    );

Map<String, dynamic> _$SquareShapeCommandToJson(SquareShapeCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'topLeft': const OffsetConverter().toJson(instance.topLeft),
      'topRight': const OffsetConverter().toJson(instance.topRight),
      'bottomLeft': const OffsetConverter().toJson(instance.bottomLeft),
      'bottomRight': const OffsetConverter().toJson(instance.bottomRight),
      'version': instance.version,
      'type': instance.type,
    };
