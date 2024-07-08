// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shapes_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShapesCommand _$ShapesCommandFromJson(Map<String, dynamic> json) =>
    ShapesCommand(
      const RectConverter().fromJson(json['rect'] as Map<String, dynamic>),
      $enumDecode(_$ShapeTypeEnumMap, json['shapeType']),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.SHAPES_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShapesCommandToJson(ShapesCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'rect': const RectConverter().toJson(instance.rect),
      'type': instance.type,
      'version': instance.version,
      'shapeType': _$ShapeTypeEnumMap[instance.shapeType]!,
    };

const _$ShapeTypeEnumMap = {
  ShapeType.rectangle: 'rectangle',
};
