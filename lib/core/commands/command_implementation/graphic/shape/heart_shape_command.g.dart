// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_shape_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeartShapeCommand _$HeartShapeCommandFromJson(Map<String, dynamic> json) =>
    HeartShapeCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      (json['width'] as num).toDouble(),
      (json['height'] as num).toDouble(),
      (json['angle'] as num).toDouble(),
      const OffsetConverter().fromJson(json['center'] as Map<String, dynamic>),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.HEART_SHAPE_COMMAND,
    );

Map<String, dynamic> _$HeartShapeCommandToJson(HeartShapeCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'width': instance.width,
      'height': instance.height,
      'angle': instance.angle,
      'center': const OffsetConverter().toJson(instance.center),
      'version': instance.version,
      'type': instance.type,
    };
