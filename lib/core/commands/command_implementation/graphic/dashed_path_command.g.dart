// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashed_path_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashedPathCommand _$DashedPathCommandFromJson(Map<String, dynamic> json) =>
    DashedPathCommand(
      const PathWithActionHistoryConverter()
          .fromJson(json['path'] as Map<String, dynamic>),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.DASHED_PATH_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DashedPathCommandToJson(DashedPathCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'path': const PathWithActionHistoryConverter().toJson(instance.path),
    };
