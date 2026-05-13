// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathModel _$PathModelFromJson(Map<String, dynamic> json) => PathModel(
      version: (json['version'] as num?)?.toInt(),
    )..fillType = $enumDecode(_$PathFillTypeEnumMap, json['fillType']);

Map<String, dynamic> _$PathModelToJson(PathModel instance) => <String, dynamic>{
      'version': instance.version,
      'fillType': _$PathFillTypeEnumMap[instance.fillType]!,
    };

const _$PathFillTypeEnumMap = {
  PathFillType.nonZero: 'nonZero',
  PathFillType.evenOdd: 'evenOdd',
};
