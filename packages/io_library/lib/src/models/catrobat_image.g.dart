// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catrobat_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatrobatImage _$CatrobatImageFromJson(Map<String, dynamic> json) =>
    CatrobatImage(
      (json['commands'] as List<dynamic>)
          .map((e) => Command.fromJson(e as Map<String, dynamic>)),
      json['width'] as int,
      json['height'] as int,
      json['backgroundImage'] as String,
      version: json['version'] as int?,
      magicValue: json['magicValue'] as String? ?? 'CATROBAT',
    );

Map<String, dynamic> _$CatrobatImageToJson(CatrobatImage instance) =>
    <String, dynamic>{
      'magicValue': instance.magicValue,
      'version': instance.version,
      'width': instance.width,
      'height': instance.height,
      'commands': instance.commands.toList(),
      'backgroundImage': instance.backgroundImage,
    };
