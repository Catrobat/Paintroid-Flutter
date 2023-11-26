//
//  Generated code. Do not modify.
//  source: graphic/path.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath$json = {
  '1': 'SerializablePath',
  '2': [
    {'1': 'actions', '3': 1, '4': 3, '5': 11, '6': '.SerializablePath.Action', '10': 'actions'},
    {'1': 'fill_type', '3': 2, '4': 1, '5': 14, '6': '.SerializablePath.FillType', '10': 'fillType'},
  ],
  '3': [SerializablePath_Action$json],
  '4': [SerializablePath_FillType$json],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'move_to', '3': 1, '4': 1, '5': 11, '6': '.SerializablePath.Action.MoveTo', '9': 0, '10': 'moveTo'},
    {'1': 'line_to', '3': 2, '4': 1, '5': 11, '6': '.SerializablePath.Action.LineTo', '9': 0, '10': 'lineTo'},
    {'1': 'close', '3': 3, '4': 1, '5': 11, '6': '.SerializablePath.Action.Close', '9': 0, '10': 'close'},
  ],
  '3': [SerializablePath_Action_MoveTo$json, SerializablePath_Action_LineTo$json, SerializablePath_Action_Close$json],
  '8': [
    {'1': 'action'},
  ],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action_MoveTo$json = {
  '1': 'MoveTo',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action_LineTo$json = {
  '1': 'LineTo',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_Action_Close$json = {
  '1': 'Close',
};

@$core.Deprecated('Use serializablePathDescriptor instead')
const SerializablePath_FillType$json = {
  '1': 'FillType',
  '2': [
    {'1': 'NON_ZERO', '2': 0},
    {'1': 'EVEN_ODD', '2': 1},
  ],
};

/// Descriptor for `SerializablePath`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializablePathDescriptor = $convert.base64Decode(
    'ChBTZXJpYWxpemFibGVQYXRoEjIKB2FjdGlvbnMYASADKAsyGC5TZXJpYWxpemFibGVQYXRoLk'
    'FjdGlvblIHYWN0aW9ucxI3CglmaWxsX3R5cGUYAiABKA4yGi5TZXJpYWxpemFibGVQYXRoLkZp'
    'bGxUeXBlUghmaWxsVHlwZRqXAgoGQWN0aW9uEjoKB21vdmVfdG8YASABKAsyHy5TZXJpYWxpem'
    'FibGVQYXRoLkFjdGlvbi5Nb3ZlVG9IAFIGbW92ZVRvEjoKB2xpbmVfdG8YAiABKAsyHy5TZXJp'
    'YWxpemFibGVQYXRoLkFjdGlvbi5MaW5lVG9IAFIGbGluZVRvEjYKBWNsb3NlGAMgASgLMh4uU2'
    'VyaWFsaXphYmxlUGF0aC5BY3Rpb24uQ2xvc2VIAFIFY2xvc2UaJAoGTW92ZVRvEgwKAXgYASAB'
    'KAFSAXgSDAoBeRgCIAEoAVIBeRokCgZMaW5lVG8SDAoBeBgBIAEoAVIBeBIMCgF5GAIgASgBUg'
    'F5GgcKBUNsb3NlQggKBmFjdGlvbiImCghGaWxsVHlwZRIMCghOT05fWkVSTxAAEgwKCEVWRU5f'
    'T0REEAE=');

