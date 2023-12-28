//
//  Generated code. Do not modify.
//  source: catrobat_image.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serializableCatrobatImageDescriptor instead')
const SerializableCatrobatImage$json = {
  '1': 'SerializableCatrobatImage',
  '2': [
    {'1': 'magicValue', '3': 1, '4': 1, '5': 9, '10': 'magicValue'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'width', '3': 3, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 13, '10': 'height'},
    {
      '1': 'commands',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'commands'
    },
    {'1': 'backgroundImage', '3': 6, '4': 1, '5': 12, '10': 'backgroundImage'},
  ],
};

/// Descriptor for `SerializableCatrobatImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializableCatrobatImageDescriptor = $convert.base64Decode(
    'ChlTZXJpYWxpemFibGVDYXRyb2JhdEltYWdlEh4KCm1hZ2ljVmFsdWUYASABKAlSCm1hZ2ljVm'
    'FsdWUSGAoHdmVyc2lvbhgCIAEoBVIHdmVyc2lvbhIUCgV3aWR0aBgDIAEoDVIFd2lkdGgSFgoG'
    'aGVpZ2h0GAQgASgNUgZoZWlnaHQSMAoIY29tbWFuZHMYBSADKAsyFC5nb29nbGUucHJvdG9idW'
    'YuQW55Ughjb21tYW5kcxIoCg9iYWNrZ3JvdW5kSW1hZ2UYBiABKAxSD2JhY2tncm91bmRJbWFn'
    'ZQ==');
