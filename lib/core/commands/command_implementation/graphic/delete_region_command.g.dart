// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_region_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteRegionCommand _$DeleteRegionCommandFromJson(Map<String, dynamic> json) =>
    DeleteRegionCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      const RectConverter().fromJson(json['region'] as Map<String, dynamic>),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.DELETE_REGION_COMMAND,
    );

Map<String, dynamic> _$DeleteRegionCommandToJson(
        DeleteRegionCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'region': const RectConverter().toJson(instance.region),
      'version': instance.version,
      'type': instance.type,
    };
