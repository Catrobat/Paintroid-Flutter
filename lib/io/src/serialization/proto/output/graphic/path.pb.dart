///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'path.pbenum.dart';

export 'path.pbenum.dart';

class SerializablePath_Action_MoveTo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializablePath.Action.MoveTo', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  SerializablePath_Action_MoveTo._() : super();
  factory SerializablePath_Action_MoveTo({
    $core.double? x,
    $core.double? y,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    return _result;
  }
  factory SerializablePath_Action_MoveTo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePath_Action_MoveTo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePath_Action_MoveTo clone() => SerializablePath_Action_MoveTo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePath_Action_MoveTo copyWith(void Function(SerializablePath_Action_MoveTo) updates) => super.copyWith((message) => updates(message as SerializablePath_Action_MoveTo)) as SerializablePath_Action_MoveTo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action_MoveTo create() => SerializablePath_Action_MoveTo._();
  SerializablePath_Action_MoveTo createEmptyInstance() => create();
  static $pb.PbList<SerializablePath_Action_MoveTo> createRepeated() => $pb.PbList<SerializablePath_Action_MoveTo>();
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action_MoveTo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializablePath_Action_MoveTo>(create);
  static SerializablePath_Action_MoveTo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class SerializablePath_Action_LineTo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializablePath.Action.LineTo', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  SerializablePath_Action_LineTo._() : super();
  factory SerializablePath_Action_LineTo({
    $core.double? x,
    $core.double? y,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    return _result;
  }
  factory SerializablePath_Action_LineTo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePath_Action_LineTo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePath_Action_LineTo clone() => SerializablePath_Action_LineTo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePath_Action_LineTo copyWith(void Function(SerializablePath_Action_LineTo) updates) => super.copyWith((message) => updates(message as SerializablePath_Action_LineTo)) as SerializablePath_Action_LineTo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action_LineTo create() => SerializablePath_Action_LineTo._();
  SerializablePath_Action_LineTo createEmptyInstance() => create();
  static $pb.PbList<SerializablePath_Action_LineTo> createRepeated() => $pb.PbList<SerializablePath_Action_LineTo>();
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action_LineTo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializablePath_Action_LineTo>(create);
  static SerializablePath_Action_LineTo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class SerializablePath_Action_Close extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializablePath.Action.Close', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SerializablePath_Action_Close._() : super();
  factory SerializablePath_Action_Close() => create();
  factory SerializablePath_Action_Close.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePath_Action_Close.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePath_Action_Close clone() => SerializablePath_Action_Close()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePath_Action_Close copyWith(void Function(SerializablePath_Action_Close) updates) => super.copyWith((message) => updates(message as SerializablePath_Action_Close)) as SerializablePath_Action_Close; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action_Close create() => SerializablePath_Action_Close._();
  SerializablePath_Action_Close createEmptyInstance() => create();
  static $pb.PbList<SerializablePath_Action_Close> createRepeated() => $pb.PbList<SerializablePath_Action_Close>();
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action_Close getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializablePath_Action_Close>(create);
  static SerializablePath_Action_Close? _defaultInstance;
}

enum SerializablePath_Action_Action {
  moveTo, 
  lineTo, 
  close, 
  notSet
}

class SerializablePath_Action extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, SerializablePath_Action_Action> _SerializablePath_Action_ActionByTag = {
    1 : SerializablePath_Action_Action.moveTo,
    2 : SerializablePath_Action_Action.lineTo,
    3 : SerializablePath_Action_Action.close,
    0 : SerializablePath_Action_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializablePath.Action', createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<SerializablePath_Action_MoveTo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveTo', subBuilder: SerializablePath_Action_MoveTo.create)
    ..aOM<SerializablePath_Action_LineTo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lineTo', subBuilder: SerializablePath_Action_LineTo.create)
    ..aOM<SerializablePath_Action_Close>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'close', subBuilder: SerializablePath_Action_Close.create)
    ..hasRequiredFields = false
  ;

  SerializablePath_Action._() : super();
  factory SerializablePath_Action({
    SerializablePath_Action_MoveTo? moveTo,
    SerializablePath_Action_LineTo? lineTo,
    SerializablePath_Action_Close? close,
  }) {
    final _result = create();
    if (moveTo != null) {
      _result.moveTo = moveTo;
    }
    if (lineTo != null) {
      _result.lineTo = lineTo;
    }
    if (close != null) {
      _result.close = close;
    }
    return _result;
  }
  factory SerializablePath_Action.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePath_Action.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePath_Action clone() => SerializablePath_Action()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePath_Action copyWith(void Function(SerializablePath_Action) updates) => super.copyWith((message) => updates(message as SerializablePath_Action)) as SerializablePath_Action; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action create() => SerializablePath_Action._();
  SerializablePath_Action createEmptyInstance() => create();
  static $pb.PbList<SerializablePath_Action> createRepeated() => $pb.PbList<SerializablePath_Action>();
  @$core.pragma('dart2js:noInline')
  static SerializablePath_Action getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializablePath_Action>(create);
  static SerializablePath_Action? _defaultInstance;

  SerializablePath_Action_Action whichAction() => _SerializablePath_Action_ActionByTag[$_whichOneof(0)]!;
  void clearAction() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SerializablePath_Action_MoveTo get moveTo => $_getN(0);
  @$pb.TagNumber(1)
  set moveTo(SerializablePath_Action_MoveTo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMoveTo() => $_has(0);
  @$pb.TagNumber(1)
  void clearMoveTo() => clearField(1);
  @$pb.TagNumber(1)
  SerializablePath_Action_MoveTo ensureMoveTo() => $_ensure(0);

  @$pb.TagNumber(2)
  SerializablePath_Action_LineTo get lineTo => $_getN(1);
  @$pb.TagNumber(2)
  set lineTo(SerializablePath_Action_LineTo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLineTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearLineTo() => clearField(2);
  @$pb.TagNumber(2)
  SerializablePath_Action_LineTo ensureLineTo() => $_ensure(1);

  @$pb.TagNumber(3)
  SerializablePath_Action_Close get close => $_getN(2);
  @$pb.TagNumber(3)
  set close(SerializablePath_Action_Close v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasClose() => $_has(2);
  @$pb.TagNumber(3)
  void clearClose() => clearField(3);
  @$pb.TagNumber(3)
  SerializablePath_Action_Close ensureClose() => $_ensure(2);
}

class SerializablePath extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SerializablePath', createEmptyInstance: create)
    ..pc<SerializablePath_Action>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actions', $pb.PbFieldType.PM, subBuilder: SerializablePath_Action.create)
    ..e<SerializablePath_FillType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fillType', $pb.PbFieldType.OE, defaultOrMaker: SerializablePath_FillType.NON_ZERO, valueOf: SerializablePath_FillType.valueOf, enumValues: SerializablePath_FillType.values)
    ..hasRequiredFields = false
  ;

  SerializablePath._() : super();
  factory SerializablePath({
    $core.Iterable<SerializablePath_Action>? actions,
    SerializablePath_FillType? fillType,
  }) {
    final _result = create();
    if (actions != null) {
      _result.actions.addAll(actions);
    }
    if (fillType != null) {
      _result.fillType = fillType;
    }
    return _result;
  }
  factory SerializablePath.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerializablePath.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerializablePath clone() => SerializablePath()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerializablePath copyWith(void Function(SerializablePath) updates) => super.copyWith((message) => updates(message as SerializablePath)) as SerializablePath; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SerializablePath create() => SerializablePath._();
  SerializablePath createEmptyInstance() => create();
  static $pb.PbList<SerializablePath> createRepeated() => $pb.PbList<SerializablePath>();
  @$core.pragma('dart2js:noInline')
  static SerializablePath getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerializablePath>(create);
  static SerializablePath? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SerializablePath_Action> get actions => $_getList(0);

  @$pb.TagNumber(2)
  SerializablePath_FillType get fillType => $_getN(1);
  @$pb.TagNumber(2)
  set fillType(SerializablePath_FillType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFillType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFillType() => clearField(2);
}

