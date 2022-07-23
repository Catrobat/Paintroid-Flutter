///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/any.pb.dart' as $2;

class SerializableCatrobatImage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializableCatrobatImage', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'magicValue', protoName: 'magicValue')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..pc<$2.Any>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'commands', $pb.PbFieldType.PM, subBuilder: $2.Any.create)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loadedImage', $pb.PbFieldType.OY, protoName: 'loadedImage')
    ..hasRequiredFields = false
  ;

  SerializableCatrobatImage._() : super();
  factory SerializableCatrobatImage({
    $core.String? magicValue,
    $core.int? version,
    $core.Iterable<$2.Any>? commands,
    $core.List<$core.int>? loadedImage,
  }) {
    final _result = create();
    if (magicValue != null) {
      _result.magicValue = magicValue;
    }
    if (version != null) {
      _result.version = version;
    }
    if (commands != null) {
      _result.commands.addAll(commands);
    }
    if (loadedImage != null) {
      _result.loadedImage = loadedImage;
    }
    return _result;
  }
  factory SerializableCatrobatImage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializableCatrobatImage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializableCatrobatImage clone() => SerializableCatrobatImage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializableCatrobatImage copyWith(void Function(SerializableCatrobatImage) updates) => super.copyWith((message) => updates(message as SerializableCatrobatImage)) as SerializableCatrobatImage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializableCatrobatImage create() => SerializableCatrobatImage._();
  SerializableCatrobatImage createEmptyInstance() => create();
  static $pb.PbList<SerializableCatrobatImage> createRepeated() => $pb.PbList<SerializableCatrobatImage>();
  @$core.pragma('dart2js:noInline')
  static SerializableCatrobatImage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializableCatrobatImage>(create);
  static SerializableCatrobatImage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get magicValue => $_getSZ(0);
  @$pb.TagNumber(1)
  set magicValue($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMagicValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearMagicValue() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$2.Any> get commands => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.int> get loadedImage => $_getN(3);
  @$pb.TagNumber(4)
  set loadedImage($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLoadedImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearLoadedImage() => clearField(4);
}

