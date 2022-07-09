///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'paint.pbenum.dart';

export 'paint.pbenum.dart';

class SerializablePaint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializablePaint', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'color', $pb.PbFieldType.O3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strokeWidth', $pb.PbFieldType.OF, protoName: 'strokeWidth')
    ..e<SerializablePaint_StrokeCap>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cap', $pb.PbFieldType.OE, defaultOrMaker: SerializablePaint_StrokeCap.ROUND, valueOf: SerializablePaint_StrokeCap.valueOf, enumValues: SerializablePaint_StrokeCap.values)
    ..hasRequiredFields = false
  ;

  SerializablePaint._() : super();
  factory SerializablePaint({
    $core.int? color,
    $core.double? strokeWidth,
    SerializablePaint_StrokeCap? cap,
  }) {
    final _result = create();
    if (color != null) {
      _result.color = color;
    }
    if (strokeWidth != null) {
      _result.strokeWidth = strokeWidth;
    }
    if (cap != null) {
      _result.cap = cap;
    }
    return _result;
  }
  factory SerializablePaint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePaint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePaint clone() => SerializablePaint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePaint copyWith(void Function(SerializablePaint) updates) => super.copyWith((message) => updates(message as SerializablePaint)) as SerializablePaint; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePaint create() => SerializablePaint._();
  SerializablePaint createEmptyInstance() => create();
  static $pb.PbList<SerializablePaint> createRepeated() => $pb.PbList<SerializablePaint>();
  @$core.pragma('dart2js:noInline')
  static SerializablePaint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializablePaint>(create);
  static SerializablePaint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get color => $_getIZ(0);
  @$pb.TagNumber(1)
  set color($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get strokeWidth => $_getN(1);
  @$pb.TagNumber(2)
  set strokeWidth($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStrokeWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearStrokeWidth() => clearField(2);

  @$pb.TagNumber(3)
  SerializablePaint_StrokeCap get cap => $_getN(2);
  @$pb.TagNumber(3)
  set cap(SerializablePaint_StrokeCap v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCap() => $_has(2);
  @$pb.TagNumber(3)
  void clearCap() => clearField(3);
}

