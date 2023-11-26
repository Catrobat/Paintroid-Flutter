//
//  Generated code. Do not modify.
//  source: catrobat_image.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/any.pb.dart' as $2;

class SerializableCatrobatImage extends $pb.GeneratedMessage {
  factory SerializableCatrobatImage({
    $core.String? magicValue,
    $core.int? version,
    $core.int? width,
    $core.int? height,
    $core.Iterable<$2.Any>? commands,
    $core.List<$core.int>? backgroundImage,
  }) {
    final $result = create();
    if (magicValue != null) {
      $result.magicValue = magicValue;
    }
    if (version != null) {
      $result.version = version;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (commands != null) {
      $result.commands.addAll(commands);
    }
    if (backgroundImage != null) {
      $result.backgroundImage = backgroundImage;
    }
    return $result;
  }
  SerializableCatrobatImage._() : super();
  factory SerializableCatrobatImage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializableCatrobatImage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SerializableCatrobatImage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'magicValue', protoName: 'magicValue')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..pc<$2.Any>(5, _omitFieldNames ? '' : 'commands', $pb.PbFieldType.PM, subBuilder: $2.Any.create)
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'backgroundImage', $pb.PbFieldType.OY, protoName: 'backgroundImage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializableCatrobatImage clone() => SerializableCatrobatImage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializableCatrobatImage copyWith(void Function(SerializableCatrobatImage) updates) => super.copyWith((message) => updates(message as SerializableCatrobatImage)) as SerializableCatrobatImage;

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
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$2.Any> get commands => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$core.int> get backgroundImage => $_getN(5);
  @$pb.TagNumber(6)
  set backgroundImage($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasBackgroundImage() => $_has(5);
  @$pb.TagNumber(6)
  void clearBackgroundImage() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
