///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use serializableDrawPathCommandDescriptor instead')
const SerializableDrawPathCommand$json = const {
  '1': 'SerializableDrawPathCommand',
  '2': const [
    const {'1': 'paint', '3': 1, '4': 1, '5': 11, '6': '.SerializablePaint', '10': 'paint'},
    const {'1': 'path', '3': 2, '4': 1, '5': 11, '6': '.SerializablePath', '10': 'path'},
  ],
};

/// Descriptor for `SerializableDrawPathCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializableDrawPathCommandDescriptor = $convert.base64Decode('ChtTZXJpYWxpemFibGVEcmF3UGF0aENvbW1hbmQSKAoFcGFpbnQYASABKAsyEi5TZXJpYWxpemFibGVQYWludFIFcGFpbnQSJQoEcGF0aBgCIAEoCzIRLlNlcmlhbGl6YWJsZVBhdGhSBHBhdGg=');
