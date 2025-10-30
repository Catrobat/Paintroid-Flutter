// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ellipse_shape_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EllipseShapeCommand _$EllipseShapeCommandFromJson(Map<String, dynamic> json) =>
    EllipseShapeCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      (json['radiusX'] as num).toDouble(),
      (json['radiusY'] as num).toDouble(),
      const OffsetConverter().fromJson(json['center'] as Map<String, dynamic>),
      $enumDecode(_$ShapeStyleEnumMap, json['style']),
      (json['angle'] as num).toDouble(),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.ELLIPSE_SHAPE_COMMAND,
    );

Map<String, dynamic> _$EllipseShapeCommandToJson(
        EllipseShapeCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'radiusX': instance.radiusX,
      'radiusY': instance.radiusY,
      'center': const OffsetConverter().toJson(instance.center),
      'angle': instance.angle,
      'style': _$ShapeStyleEnumMap[instance.style]!,
      'version': instance.version,
      'type': instance.type,
    };

const _$ShapeStyleEnumMap = {
  ShapeStyle.fill: 'fill',
  ShapeStyle.outline: 'outline',
  ShapeStyle.fillAndDashed: 'fillAndDashed',
  ShapeStyle.dashed: 'dashed',
};
