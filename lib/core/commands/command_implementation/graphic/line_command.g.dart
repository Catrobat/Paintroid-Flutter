// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineCommand _$LineCommandFromJson(Map<String, dynamic> json) => LineCommand(
      const PathWithActionHistoryConverter()
          .fromJson(json['path'] as Map<String, dynamic>),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['startPoint'] as Map<String, dynamic>),
      const OffsetConverter()
          .fromJson(json['endPoint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.LINE_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    )..isSourcePath = json['isSourcePath'] as bool;

Map<String, dynamic> _$LineCommandToJson(LineCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'isSourcePath': instance.isSourcePath,
      'path': const PathWithActionHistoryConverter().toJson(instance.path),
      'startPoint': const OffsetConverter().toJson(instance.startPoint),
      'endPoint': const OffsetConverter().toJson(instance.endPoint),
    };
