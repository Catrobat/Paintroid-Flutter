//
//  Generated code. Do not modify.
//  source: command/graphic/draw_path_command.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../graphic/paint.pb.dart' as $0;
import '../../graphic/path.pb.dart' as $1;

class SerializableDrawPathCommand extends $pb.GeneratedMessage {
  factory SerializableDrawPathCommand({
    $0.SerializablePaint? paint,
    $1.SerializablePath? path,
  }) {
    final $result = create();
    if (paint != null) {
      $result.paint = paint;
    }
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  SerializableDrawPathCommand._() : super();
  factory SerializableDrawPathCommand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SerializableDrawPathCommand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializableDrawPathCommand',
      createEmptyInstance: create)
    ..aOM<$0.SerializablePaint>(1, _omitFieldNames ? '' : 'paint',
        subBuilder: $0.SerializablePaint.create)
    ..aOM<$1.SerializablePath>(2, _omitFieldNames ? '' : 'path',
        subBuilder: $1.SerializablePath.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SerializableDrawPathCommand clone() =>
      SerializableDrawPathCommand()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SerializableDrawPathCommand copyWith(
          void Function(SerializableDrawPathCommand) updates) =>
      super.copyWith(
              (message) => updates(message as SerializableDrawPathCommand))
          as SerializableDrawPathCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializableDrawPathCommand create() =>
      SerializableDrawPathCommand._();
  SerializableDrawPathCommand createEmptyInstance() => create();
  static $pb.PbList<SerializableDrawPathCommand> createRepeated() =>
      $pb.PbList<SerializableDrawPathCommand>();
  @$core.pragma('dart2js:noInline')
  static SerializableDrawPathCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializableDrawPathCommand>(create);
  static SerializableDrawPathCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SerializablePaint get paint => $_getN(0);
  @$pb.TagNumber(1)
  set paint($0.SerializablePaint v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPaint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaint() => clearField(1);
  @$pb.TagNumber(1)
  $0.SerializablePaint ensurePaint() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.SerializablePath get path => $_getN(1);
  @$pb.TagNumber(2)
  set path($1.SerializablePath v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);
  @$pb.TagNumber(2)
  $1.SerializablePath ensurePath() => $_ensure(1);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
