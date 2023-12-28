//
//  Generated code. Do not modify.
//  source: graphic/paint.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serializablePaintDescriptor instead')
const SerializablePaint$json = {
  '1': 'SerializablePaint',
  '2': [
    {'1': 'color', '3': 1, '4': 1, '5': 13, '10': 'color'},
    {'1': 'strokeWidth', '3': 2, '4': 1, '5': 2, '10': 'strokeWidth'},
    {
      '1': 'cap',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.SerializablePaint.StrokeCap',
      '10': 'cap'
    },
    {
      '1': 'style',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.SerializablePaint.PaintingStyle',
      '10': 'style'
    },
    {
      '1': 'blendMode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.SerializablePaint.BlendMode',
      '10': 'blendMode'
    },
    {
      '1': 'strokeJoin',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.SerializablePaint.StrokeJoin',
      '10': 'strokeJoin'
    },
  ],
  '4': [
    SerializablePaint_StrokeCap$json,
    SerializablePaint_PaintingStyle$json,
    SerializablePaint_BlendMode$json,
    SerializablePaint_StrokeJoin$json
  ],
};

@$core.Deprecated('Use serializablePaintDescriptor instead')
const SerializablePaint_StrokeCap$json = {
  '1': 'StrokeCap',
  '2': [
    {'1': 'STROKE_CAP_ROUND', '2': 0},
    {'1': 'STROKE_CAP_BUTT', '2': 1},
    {'1': 'STROKE_CAP_SQUARE', '2': 2},
  ],
};

@$core.Deprecated('Use serializablePaintDescriptor instead')
const SerializablePaint_PaintingStyle$json = {
  '1': 'PaintingStyle',
  '2': [
    {'1': 'PAINTING_STYLE_FILL', '2': 0},
    {'1': 'PAINTING_STYLE_STROKE', '2': 1},
  ],
};

@$core.Deprecated('Use serializablePaintDescriptor instead')
const SerializablePaint_BlendMode$json = {
  '1': 'BlendMode',
  '2': [
    {'1': 'BLEND_MODE_SCR_OVER', '2': 0},
    {'1': 'BLEND_MODE_CLEAR', '2': 1},
  ],
};

@$core.Deprecated('Use serializablePaintDescriptor instead')
const SerializablePaint_StrokeJoin$json = {
  '1': 'StrokeJoin',
  '2': [
    {'1': 'STROKE_JOIN_MITER', '2': 0},
    {'1': 'STROKE_JOIN_ROUND', '2': 1},
    {'1': 'STROKE_JOIN_BEVEL', '2': 2},
  ],
};

/// Descriptor for `SerializablePaint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializablePaintDescriptor = $convert.base64Decode(
    'ChFTZXJpYWxpemFibGVQYWludBIUCgVjb2xvchgBIAEoDVIFY29sb3ISIAoLc3Ryb2tlV2lkdG'
    'gYAiABKAJSC3N0cm9rZVdpZHRoEi4KA2NhcBgDIAEoDjIcLlNlcmlhbGl6YWJsZVBhaW50LlN0'
    'cm9rZUNhcFIDY2FwEjYKBXN0eWxlGAQgASgOMiAuU2VyaWFsaXphYmxlUGFpbnQuUGFpbnRpbm'
    'dTdHlsZVIFc3R5bGUSOgoJYmxlbmRNb2RlGAUgASgOMhwuU2VyaWFsaXphYmxlUGFpbnQuQmxl'
    'bmRNb2RlUglibGVuZE1vZGUSPQoKc3Ryb2tlSm9pbhgGIAEoDjIdLlNlcmlhbGl6YWJsZVBhaW'
    '50LlN0cm9rZUpvaW5SCnN0cm9rZUpvaW4iTQoJU3Ryb2tlQ2FwEhQKEFNUUk9LRV9DQVBfUk9V'
    'TkQQABITCg9TVFJPS0VfQ0FQX0JVVFQQARIVChFTVFJPS0VfQ0FQX1NRVUFSRRACIkMKDVBhaW'
    '50aW5nU3R5bGUSFwoTUEFJTlRJTkdfU1RZTEVfRklMTBAAEhkKFVBBSU5USU5HX1NUWUxFX1NU'
    'Uk9LRRABIjoKCUJsZW5kTW9kZRIXChNCTEVORF9NT0RFX1NDUl9PVkVSEAASFAoQQkxFTkRfTU'
    '9ERV9DTEVBUhABIlEKClN0cm9rZUpvaW4SFQoRU1RST0tFX0pPSU5fTUlURVIQABIVChFTVFJP'
    'S0VfSk9JTl9ST1VORBABEhUKEVNUUk9LRV9KT0lOX0JFVkVMEAI=');
