// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star_shape_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarShapeCommand _$StarShapeCommandFromJson(Map<String, dynamic> json) =>
    StarShapeCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      (json['numberOfPoints'] as num).toInt(),
      (json['angle'] as num).toDouble(),
      const OffsetConverter().fromJson(json['center'] as Map<String, dynamic>),
      $enumDecode(_$ShapeStyleEnumMap, json['style']),
      (json['radiusX'] as num).toDouble(),
      (json['radiusY'] as num).toDouble(),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.STAR_SHAPE_COMMAND,
    );

Map<String, dynamic> _$StarShapeCommandToJson(StarShapeCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'numberOfPoints': instance.numberOfPoints,
      'angle': instance.angle,
      'center': const OffsetConverter().toJson(instance.center),
      'style': _$ShapeStyleEnumMap[instance.style]!,
      'radiusX': instance.radiusX,
      'radiusY': instance.radiusY,
      'version': instance.version,
      'type': instance.type,
    };

const _$ShapeStyleEnumMap = {
  ShapeStyle.fill: 'fill',
  ShapeStyle.outline: 'outline',
  ShapeStyle.fillAndDashed: 'fillAndDashed',
  ShapeStyle.dashed: 'dashed',
};
