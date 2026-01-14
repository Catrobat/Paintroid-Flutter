// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_changed_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorChangedCommand _$ColorChangedCommandFromJson(Map<String, dynamic> json) =>
    ColorChangedCommand(
      oldColor:
          const ColorConverter().fromJson((json['oldColor'] as num).toInt()),
      newColor:
          const ColorConverter().fromJson((json['newColor'] as num).toInt()),
      paint: const PaintConverter()
          .fromJson(json['paint'] as Map<String, dynamic>),
      type: json['type'] as String? ?? SerializerType.COLOR_CHANGED_COMMAND,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ColorChangedCommandToJson(
        ColorChangedCommand instance) =>
    <String, dynamic>{
      'paint': const PaintConverter().toJson(instance.paint),
      'type': instance.type,
      'version': instance.version,
      'oldColor': const ColorConverter().toJson(instance.oldColor),
      'newColor': const ColorConverter().toJson(instance.newColor),
    };
