///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use serializableCatrobatImageDescriptor instead')
const SerializableCatrobatImage$json = const {
  '1': 'SerializableCatrobatImage',
  '2': const [
    const {'1': 'magicValue', '3': 1, '4': 1, '5': 9, '10': 'magicValue'},
    const {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'commands', '3': 3, '4': 3, '5': 11, '6': '.google.protobuf.Any', '10': 'commands'},
    const {'1': 'loadedImage', '3': 4, '4': 1, '5': 12, '9': 0, '10': 'loadedImage', '17': true},
  ],
  '8': const [
    const {'1': '_loadedImage'},
  ],
};

/// Descriptor for `SerializableCatrobatImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializableCatrobatImageDescriptor = $convert.base64Decode('ChlTZXJpYWxpemFibGVDYXRyb2JhdEltYWdlEh4KCm1hZ2ljVmFsdWUYASABKAlSCm1hZ2ljVmFsdWUSGAoHdmVyc2lvbhgCIAEoBVIHdmVyc2lvbhIwCghjb21tYW5kcxgDIAMoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSCGNvbW1hbmRzEiUKC2xvYWRlZEltYWdlGAQgASgMSABSC2xvYWRlZEltYWdliAEBQg4KDF9sb2FkZWRJbWFnZQ==');
