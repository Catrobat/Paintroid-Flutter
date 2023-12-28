//
//  Generated code. Do not modify.
//  source: command/graphic/draw_path_command.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serializableDrawPathCommandDescriptor instead')
const SerializableDrawPathCommand$json = {
  '1': 'SerializableDrawPathCommand',
  '2': [
    {
      '1': 'paint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.SerializablePaint',
      '10': 'paint'
    },
    {
      '1': 'path',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.SerializablePath',
      '10': 'path'
    },
  ],
};

/// Descriptor for `SerializableDrawPathCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializableDrawPathCommandDescriptor =
    $convert.base64Decode(
        'ChtTZXJpYWxpemFibGVEcmF3UGF0aENvbW1hbmQSKAoFcGFpbnQYASABKAsyEi5TZXJpYWxpem'
        'FibGVQYWludFIFcGFpbnQSJQoEcGF0aBgCIAEoCzIRLlNlcmlhbGl6YWJsZVBhdGhSBHBhdGg=');
