// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_shape_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleShapeCommand _$CircleShapeCommandFromJson(Map<String, dynamic> json) =>
    CircleShapeCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      (json['radius'] as num).toDouble(),
      const OffsetConverter().fromJson(json['center'] as Map<String, dynamic>),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.CIRCLE_SHAPE_COMMAND,
    );

Map<String, dynamic> _$CircleShapeCommandToJson(CircleShapeCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'radius': instance.radius,
      'center': const OffsetConverter().toJson(instance.center),
      'version': instance.version,
      'type': instance.type,
    };
