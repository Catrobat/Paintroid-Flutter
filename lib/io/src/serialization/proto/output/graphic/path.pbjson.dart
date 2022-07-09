///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath$json = const {
  '1': 'SerializablePath',
  '2': const [
    const {'1': 'actions', '3': 1, '4': 3, '5': 11, '6': '.SerializablePath.Action', '10': 'actions'},
    const {'1': 'fill_type', '3': 2, '4': 1, '5': 14, '6': '.SerializablePath.FillType', '10': 'fillType'},
  ],
  '3': const [SerializablePath_Action$json],
  '4': const [SerializablePath_FillType$json],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action$json = const {
  '1': 'Action',
  '2': const [
    const {'1': 'move_to', '3': 1, '4': 1, '5': 11, '6': '.SerializablePath.Action.MoveTo', '9': 0, '10': 'moveTo'},
    const {'1': 'line_to', '3': 2, '4': 1, '5': 11, '6': '.SerializablePath.Action.LineTo', '9': 0, '10': 'lineTo'},
    const {'1': 'close', '3': 3, '4': 1, '5': 11, '6': '.SerializablePath.Action.Close', '9': 0, '10': 'close'},
  ],
  '3': const [SerializablePath_Action_MoveTo$json, SerializablePath_Action_LineTo$json, SerializablePath_Action_Close$json],
  '8': const [
    const {'1': 'action'},
  ],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action_MoveTo$json = const {
  '1': 'MoveTo',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action_LineTo$json = const {
  '1': 'LineTo',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action_Close$json = const {
  '1': 'Close',
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_FillType$json = const {
  '1': 'FillType',
  '2': const [
    const {'1': 'NON_ZERO', '2': 0},
    const {'1': 'EVEN_ODD', '2': 1},
  ],
};

/// Descriptor for `SerializablePath`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializablePathDescriptor = $convert.base64Decode('ChBTZXJpYWxpemFibGVQYXRoEjIKB2FjdGlvbnMYASADKAsyGC5TZXJpYWxpemFibGVQYXRoLkFjdGlvblIHYWN0aW9ucxI3CglmaWxsX3R5cGUYAiABKA4yGi5TZXJpYWxpemFibGVQYXRoLkZpbGxUeXBlUghmaWxsVHlwZRqXAgoGQWN0aW9uEjoKB21vdmVfdG8YASABKAsyHy5TZXJpYWxpemFibGVQYXRoLkFjdGlvbi5Nb3ZlVG9IAFIGbW92ZVRvEjoKB2xpbmVfdG8YAiABKAsyHy5TZXJpYWxpemFibGVQYXRoLkFjdGlvbi5MaW5lVG9IAFIGbGluZVRvEjYKBWNsb3NlGAMgASgLMh4uU2VyaWFsaXphYmxlUGF0aC5BY3Rpb24uQ2xvc2VIAFIFY2xvc2UaJAoGTW92ZVRvEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeRokCgZMaW5lVG8SDAoBeBgBIAEoAVIBeBIMCgF5GAIgASgBUgF5GgcKBUNsb3NlQggKBmFjdGlvbiImCghGaWxsVHlwZRIMCghOT05fWkVSTxAAEgwKCEVWRU5fT0REEAE=');
