// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_path_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipPathCommand _$ClipPathCommandFromJson(Map<String, dynamic> json) =>
    ClipPathCommand(
      const PathWithActionHistoryConverter()
          .fromJson(json['path'] as Map<String, dynamic>),
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      startPoint: _$JsonConverterFromJson<Map<String, dynamic>, Offset>(
          json['startPoint'], const OffsetConverter().fromJson),
      endPoint: _$JsonConverterFromJson<Map<String, dynamic>, Offset>(
          json['endPoint'], const OffsetConverter().fromJson),
      type: json['type'] as String? ?? SerializerType.CLIP_PATH_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClipPathCommandToJson(ClipPathCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'path': const PathWithActionHistoryConverter().toJson(instance.path),
      'startPoint': _$JsonConverterToJson<Map<String, dynamic>, Offset>(
          instance.startPoint, const OffsetConverter().toJson),
      'endPoint': _$JsonConverterToJson<Map<String, dynamic>, Offset>(
          instance.endPoint, const OffsetConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
