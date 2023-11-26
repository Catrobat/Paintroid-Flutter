//
//  Generated code. Do not modify.
//  source: graphic/path.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SerializablePath_FillType extends $pb.ProtobufEnum {
  static const SerializablePath_FillType NON_ZERO = SerializablePath_FillType._(0, _omitEnumNames ? '' : 'NON_ZERO');
  static const SerializablePath_FillType EVEN_ODD = SerializablePath_FillType._(1, _omitEnumNames ? '' : 'EVEN_ODD');

  static const $core.List<SerializablePath_FillType> values = <SerializablePath_FillType> [
    NON_ZERO,
    EVEN_ODD,
  ];

  static final $core.Map<$core.int, SerializablePath_FillType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SerializablePath_FillType? valueOf($core.int value) => _byValue[value];

  const SerializablePath_FillType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
