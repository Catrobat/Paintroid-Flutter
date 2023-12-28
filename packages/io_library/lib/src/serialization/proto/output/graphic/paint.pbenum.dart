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

class SerializablePaint_StrokeCap extends $pb.ProtobufEnum {
  static const SerializablePaint_StrokeCap STROKE_CAP_ROUND =
      SerializablePaint_StrokeCap._(
          0, _omitEnumNames ? '' : 'STROKE_CAP_ROUND');
  static const SerializablePaint_StrokeCap STROKE_CAP_BUTT =
      SerializablePaint_StrokeCap._(1, _omitEnumNames ? '' : 'STROKE_CAP_BUTT');
  static const SerializablePaint_StrokeCap STROKE_CAP_SQUARE =
      SerializablePaint_StrokeCap._(
          2, _omitEnumNames ? '' : 'STROKE_CAP_SQUARE');

  static const $core.List<SerializablePaint_StrokeCap> values =
      <SerializablePaint_StrokeCap>[
    STROKE_CAP_ROUND,
    STROKE_CAP_BUTT,
    STROKE_CAP_SQUARE,
  ];

  static final $core.Map<$core.int, SerializablePaint_StrokeCap> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static SerializablePaint_StrokeCap? valueOf($core.int value) =>
      _byValue[value];

  const SerializablePaint_StrokeCap._($core.int v, $core.String n)
      : super(v, n);
}

class SerializablePaint_PaintingStyle extends $pb.ProtobufEnum {
  static const SerializablePaint_PaintingStyle PAINTING_STYLE_FILL =
      SerializablePaint_PaintingStyle._(
          0, _omitEnumNames ? '' : 'PAINTING_STYLE_FILL');
  static const SerializablePaint_PaintingStyle PAINTING_STYLE_STROKE =
      SerializablePaint_PaintingStyle._(
          1, _omitEnumNames ? '' : 'PAINTING_STYLE_STROKE');

  static const $core.List<SerializablePaint_PaintingStyle> values =
      <SerializablePaint_PaintingStyle>[
    PAINTING_STYLE_FILL,
    PAINTING_STYLE_STROKE,
  ];

  static final $core.Map<$core.int, SerializablePaint_PaintingStyle> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static SerializablePaint_PaintingStyle? valueOf($core.int value) =>
      _byValue[value];

  const SerializablePaint_PaintingStyle._($core.int v, $core.String n)
      : super(v, n);
}

class SerializablePaint_BlendMode extends $pb.ProtobufEnum {
  static const SerializablePaint_BlendMode BLEND_MODE_SCR_OVER =
      SerializablePaint_BlendMode._(
          0, _omitEnumNames ? '' : 'BLEND_MODE_SCR_OVER');
  static const SerializablePaint_BlendMode BLEND_MODE_CLEAR =
      SerializablePaint_BlendMode._(
          1, _omitEnumNames ? '' : 'BLEND_MODE_CLEAR');

  static const $core.List<SerializablePaint_BlendMode> values =
      <SerializablePaint_BlendMode>[
    BLEND_MODE_SCR_OVER,
    BLEND_MODE_CLEAR,
  ];

  static final $core.Map<$core.int, SerializablePaint_BlendMode> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static SerializablePaint_BlendMode? valueOf($core.int value) =>
      _byValue[value];

  const SerializablePaint_BlendMode._($core.int v, $core.String n)
      : super(v, n);
}

class SerializablePaint_StrokeJoin extends $pb.ProtobufEnum {
  static const SerializablePaint_StrokeJoin STROKE_JOIN_MITER =
      SerializablePaint_StrokeJoin._(
          0, _omitEnumNames ? '' : 'STROKE_JOIN_MITER');
  static const SerializablePaint_StrokeJoin STROKE_JOIN_ROUND =
      SerializablePaint_StrokeJoin._(
          1, _omitEnumNames ? '' : 'STROKE_JOIN_ROUND');
  static const SerializablePaint_StrokeJoin STROKE_JOIN_BEVEL =
      SerializablePaint_StrokeJoin._(
          2, _omitEnumNames ? '' : 'STROKE_JOIN_BEVEL');

  static const $core.List<SerializablePaint_StrokeJoin> values =
      <SerializablePaint_StrokeJoin>[
    STROKE_JOIN_MITER,
    STROKE_JOIN_ROUND,
    STROKE_JOIN_BEVEL,
  ];

  static final $core.Map<$core.int, SerializablePaint_StrokeJoin> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static SerializablePaint_StrokeJoin? valueOf($core.int value) =>
      _byValue[value];

  const SerializablePaint_StrokeJoin._($core.int v, $core.String n)
      : super(v, n);
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
