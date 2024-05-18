// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathCommand _$PathCommandFromJson(Map<String, dynamic> json) => PathCommand(
      const PathWithActionHistoryConverter()
          .fromJson(json['path'] as Map<String, dynamic>),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.PATH_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PathCommandToJson(PathCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'path': const PathWithActionHistoryConverter().toJson(instance.path),
    };
