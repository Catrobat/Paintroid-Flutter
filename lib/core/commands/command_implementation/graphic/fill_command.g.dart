// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fill_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FillCommand _$FillCommandFromJson(Map<String, dynamic> json) => FillCommand(
      (json['points'] as List<dynamic>)
          .map((e) =>
              const OffsetConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.FILL_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FillCommandToJson(FillCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'points': instance.points.map(const OffsetConverter().toJson).toList(),
    };
