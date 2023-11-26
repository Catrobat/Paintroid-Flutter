//
//  Generated code. Do not modify.
//  source: graphic/paint.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'paint.pbenum.dart';

export 'paint.pbenum.dart';

class SerializablePaint extends $pb.GeneratedMessage {
  factory SerializablePaint({
    $core.int? color,
    $core.double? strokeWidth,
    SerializablePaint_StrokeCap? cap,
    SerializablePaint_PaintingStyle? style,
    SerializablePaint_BlendMode? blendMode,
    SerializablePaint_StrokeJoin? strokeJoin,
  }) {
    final $result = create();
    if (color != null) {
      $result.color = color;
    }
    if (strokeWidth != null) {
      $result.strokeWidth = strokeWidth;
    }
    if (cap != null) {
      $result.cap = cap;
    }
    if (style != null) {
      $result.style = style;
    }
    if (blendMode != null) {
      $result.blendMode = blendMode;
    }
    if (strokeJoin != null) {
      $result.strokeJoin = strokeJoin;
    }
    return $result;
  }
  SerializablePaint._() : super();
  factory SerializablePaint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePaint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SerializablePaint', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'color', $pb.PbFieldType.OU3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'strokeWidth', $pb.PbFieldType.OF, protoName: 'strokeWidth')
    ..e<SerializablePaint_StrokeCap>(3, _omitFieldNames ? '' : 'cap', $pb.PbFieldType.OE, defaultOrMaker: SerializablePaint_StrokeCap.STROKE_CAP_ROUND, valueOf: SerializablePaint_StrokeCap.valueOf, enumValues: SerializablePaint_StrokeCap.values)
    ..e<SerializablePaint_PaintingStyle>(4, _omitFieldNames ? '' : 'style', $pb.PbFieldType.OE, defaultOrMaker: SerializablePaint_PaintingStyle.PAINTING_STYLE_FILL, valueOf: SerializablePaint_PaintingStyle.valueOf, enumValues: SerializablePaint_PaintingStyle.values)
    ..e<SerializablePaint_BlendMode>(5, _omitFieldNames ? '' : 'blendMode', $pb.PbFieldType.OE, protoName: 'blendMode', defaultOrMaker: SerializablePaint_BlendMode.BLEND_MODE_SCR_OVER, valueOf: SerializablePaint_BlendMode.valueOf, enumValues: SerializablePaint_BlendMode.values)
    ..e<SerializablePaint_StrokeJoin>(6, _omitFieldNames ? '' : 'strokeJoin', $pb.PbFieldType.OE, protoName: 'strokeJoin', defaultOrMaker: SerializablePaint_StrokeJoin.STROKE_JOIN_MITER, valueOf: SerializablePaint_StrokeJoin.valueOf, enumValues: SerializablePaint_StrokeJoin.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePaint clone() => SerializablePaint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePaint copyWith(void Function(SerializablePaint) updates) => super.copyWith((message) => updates(message as SerializablePaint)) as SerializablePaint;

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
  set color($core.int v) { $_setUnsignedInt32(0, v); }
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

  @$pb.TagNumber(4)
  SerializablePaint_PaintingStyle get style => $_getN(3);
  @$pb.TagNumber(4)
  set style(SerializablePaint_PaintingStyle v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearStyle() => clearField(4);

  @$pb.TagNumber(5)
  SerializablePaint_BlendMode get blendMode => $_getN(4);
  @$pb.TagNumber(5)
  set blendMode(SerializablePaint_BlendMode v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasBlendMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearBlendMode() => clearField(5);

  @$pb.TagNumber(6)
  SerializablePaint_StrokeJoin get strokeJoin => $_getN(5);
  @$pb.TagNumber(6)
  set strokeJoin(SerializablePaint_StrokeJoin v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStrokeJoin() => $_has(5);
  @$pb.TagNumber(6)
  void clearStrokeJoin() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
