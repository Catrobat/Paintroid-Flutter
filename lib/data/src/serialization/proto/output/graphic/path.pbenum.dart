///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SerializablePath_FillType extends $pb.ProtobufEnum {
  static const SerializablePath_FillType NON_ZERO = SerializablePath_FillType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NON_ZERO');
  static const SerializablePath_FillType EVEN_ODD = SerializablePath_FillType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVEN_ODD');

  static const $core.List<SerializablePath_FillType> values = <SerializablePath_FillType> [
    NON_ZERO,
    EVEN_ODD,
  ];

  static final $core.Map<$core.int, SerializablePath_FillType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SerializablePath_FillType? valueOf($core.int value) => _byValue[value];

  const SerializablePath_FillType._($core.int v, $core.String n) : super(v, n);
}

