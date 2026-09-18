// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportCommand _$ImportCommandFromJson(Map<String, dynamic> json) =>
    ImportCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      const Uint8ListBase64Converter().fromJson(json['imageData'] as String),
      const OffsetConverter().fromJson(json['offset'] as Map<String, dynamic>),
      (json['scale'] as num).toDouble(),
      (json['rotation'] as num).toDouble(),
      version: (json['version'] as num?)?.toInt(),
      type: json['type'] as String? ?? SerializerType.IMPORT_COMMAND,
    );

Map<String, dynamic> _$ImportCommandToJson(ImportCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'imageData': const Uint8ListBase64Converter().toJson(instance.imageData),
      'offset': const OffsetConverter().toJson(instance.offset),
      'scale': instance.scale,
      'rotation': instance.rotation,
      'version': instance.version,
      'type': instance.type,
    };
