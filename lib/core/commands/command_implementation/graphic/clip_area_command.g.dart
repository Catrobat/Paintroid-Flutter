// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_area_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipAreaCommand _$ClipAreaCommandFromJson(Map<String, dynamic> json) =>
    ClipAreaCommand(
      const PathWithActionHistoryConverter()
          .fromJson(json['clipPathData'] as Map<String, dynamic>),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.CLIP_AREA_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClipAreaCommandToJson(ClipAreaCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'clipPathData':
          const PathWithActionHistoryConverter().toJson(instance.clipPathData),
    };
