// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clipboard_tool_options_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClipboardToolOptionsStateData {
  bool get hasCopiedContent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClipboardToolOptionsStateDataCopyWith<ClipboardToolOptionsStateData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClipboardToolOptionsStateDataCopyWith<$Res> {
  factory $ClipboardToolOptionsStateDataCopyWith(
          ClipboardToolOptionsStateData value,
          $Res Function(ClipboardToolOptionsStateData) then) =
      _$ClipboardToolOptionsStateDataCopyWithImpl<$Res,
          ClipboardToolOptionsStateData>;
  @useResult
  $Res call({bool hasCopiedContent});
}

/// @nodoc
class _$ClipboardToolOptionsStateDataCopyWithImpl<$Res,
        $Val extends ClipboardToolOptionsStateData>
    implements $ClipboardToolOptionsStateDataCopyWith<$Res> {
  _$ClipboardToolOptionsStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasCopiedContent = null,
  }) {
    return _then(_value.copyWith(
      hasCopiedContent: null == hasCopiedContent
          ? _value.hasCopiedContent
          : hasCopiedContent // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClipboardToolOptionsStateDataImplCopyWith<$Res>
    implements $ClipboardToolOptionsStateDataCopyWith<$Res> {
  factory _$$ClipboardToolOptionsStateDataImplCopyWith(
          _$ClipboardToolOptionsStateDataImpl value,
          $Res Function(_$ClipboardToolOptionsStateDataImpl) then) =
      __$$ClipboardToolOptionsStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasCopiedContent});
}

/// @nodoc
class __$$ClipboardToolOptionsStateDataImplCopyWithImpl<$Res>
    extends _$ClipboardToolOptionsStateDataCopyWithImpl<$Res,
        _$ClipboardToolOptionsStateDataImpl>
    implements _$$ClipboardToolOptionsStateDataImplCopyWith<$Res> {
  __$$ClipboardToolOptionsStateDataImplCopyWithImpl(
      _$ClipboardToolOptionsStateDataImpl _value,
      $Res Function(_$ClipboardToolOptionsStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasCopiedContent = null,
  }) {
    return _then(_$ClipboardToolOptionsStateDataImpl(
      hasCopiedContent: null == hasCopiedContent
          ? _value.hasCopiedContent
          : hasCopiedContent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ClipboardToolOptionsStateDataImpl
    implements _ClipboardToolOptionsStateData {
  const _$ClipboardToolOptionsStateDataImpl({this.hasCopiedContent = false});

  @override
  @JsonKey()
  final bool hasCopiedContent;

  @override
  String toString() {
    return 'ClipboardToolOptionsStateData(hasCopiedContent: $hasCopiedContent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClipboardToolOptionsStateDataImpl &&
            (identical(other.hasCopiedContent, hasCopiedContent) ||
                other.hasCopiedContent == hasCopiedContent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasCopiedContent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClipboardToolOptionsStateDataImplCopyWith<
          _$ClipboardToolOptionsStateDataImpl>
      get copyWith => __$$ClipboardToolOptionsStateDataImplCopyWithImpl<
          _$ClipboardToolOptionsStateDataImpl>(this, _$identity);
}

abstract class _ClipboardToolOptionsStateData
    implements ClipboardToolOptionsStateData {
  const factory _ClipboardToolOptionsStateData({final bool hasCopiedContent}) =
      _$ClipboardToolOptionsStateDataImpl;

  @override
  bool get hasCopiedContent;
  @override
  @JsonKey(ignore: true)
  _$$ClipboardToolOptionsStateDataImplCopyWith<
          _$ClipboardToolOptionsStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
