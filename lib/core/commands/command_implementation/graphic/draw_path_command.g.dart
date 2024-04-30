// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_path_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawPathCommand _$DrawPathCommandFromJson(Map<String, dynamic> json) =>
    DrawPathCommand(
      const PathWithActionHistoryConverter()
          .fromJson(json['path'] as Map<String, dynamic>),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.DRAW_PATH_COMMAND,
      version: json['version'] as int?,
    );

Map<String, dynamic> _$DrawPathCommandToJson(DrawPathCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'path': const PathWithActionHistoryConverter().toJson(instance.path),
    };
