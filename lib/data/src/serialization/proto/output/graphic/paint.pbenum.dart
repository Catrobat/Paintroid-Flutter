///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SerializablePaint_StrokeCap extends $pb.ProtobufEnum {
  static const SerializablePaint_StrokeCap ROUND = SerializablePaint_StrokeCap._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROUND');
  static const SerializablePaint_StrokeCap BUTT = SerializablePaint_StrokeCap._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BUTT');
  static const SerializablePaint_StrokeCap SQUARE = SerializablePaint_StrokeCap._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SQUARE');

  static const $core.List<SerializablePaint_StrokeCap> values = <SerializablePaint_StrokeCap> [
    ROUND,
    BUTT,
    SQUARE,
  ];

  static final $core.Map<$core.int, SerializablePaint_StrokeCap> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SerializablePaint_StrokeCap? valueOf($core.int value) => _byValue[value];

  const SerializablePaint_StrokeCap._($core.int v, $core.String n) : super(v, n);
}

