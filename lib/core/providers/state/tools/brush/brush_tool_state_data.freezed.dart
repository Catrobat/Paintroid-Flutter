// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brush_tool_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BrushToolStateData {
  Paint get paint => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BrushToolStateDataCopyWith<BrushToolStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrushToolStateDataCopyWith<$Res> {
  factory $BrushToolStateDataCopyWith(
          BrushToolStateData value, $Res Function(BrushToolStateData) then) =
      _$BrushToolStateDataCopyWithImpl<$Res, BrushToolStateData>;
  @useResult
  $Res call({Paint paint});
}

/// @nodoc
class _$BrushToolStateDataCopyWithImpl<$Res, $Val extends BrushToolStateData>
    implements $BrushToolStateDataCopyWith<$Res> {
  _$BrushToolStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paint = null,
  }) {
    return _then(_value.copyWith(
      paint: null == paint
          ? _value.paint
          : paint // ignore: cast_nullable_to_non_nullable
              as Paint,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BrushToolStateDataCopyWith<$Res>
    implements $BrushToolStateDataCopyWith<$Res> {
  factory _$$_BrushToolStateDataCopyWith(_$_BrushToolStateData value,
          $Res Function(_$_BrushToolStateData) then) =
      __$$_BrushToolStateDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Paint paint});
}

/// @nodoc
class __$$_BrushToolStateDataCopyWithImpl<$Res>
    extends _$BrushToolStateDataCopyWithImpl<$Res, _$_BrushToolStateData>
    implements _$$_BrushToolStateDataCopyWith<$Res> {
  __$$_BrushToolStateDataCopyWithImpl(
      _$_BrushToolStateData _value, $Res Function(_$_BrushToolStateData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paint = null,
  }) {
    return _then(_$_BrushToolStateData(
      paint: null == paint
          ? _value.paint
          : paint // ignore: cast_nullable_to_non_nullable
              as Paint,
    ));
  }
}

/// @nodoc

class _$_BrushToolStateData implements _BrushToolStateData {
  const _$_BrushToolStateData({required this.paint});

  @override
  final Paint paint;

  @override
  String toString() {
    return 'BrushToolStateData(paint: $paint)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BrushToolStateData &&
            (identical(other.paint, paint) || other.paint == paint));
  }

  @override
  int get hashCode => Object.hash(runtimeType, paint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BrushToolStateDataCopyWith<_$_BrushToolStateData> get copyWith =>
      __$$_BrushToolStateDataCopyWithImpl<_$_BrushToolStateData>(
          this, _$identity);
}

abstract class _BrushToolStateData implements BrushToolStateData {
  const factory _BrushToolStateData({required final Paint paint}) =
      _$_BrushToolStateData;

  @override
  Paint get paint;
  @override
  @JsonKey(ignore: true)
  _$$_BrushToolStateDataCopyWith<_$_BrushToolStateData> get copyWith =>
      throw _privateConstructorUsedError;
}
