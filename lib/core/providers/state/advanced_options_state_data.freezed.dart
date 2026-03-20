// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_options_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdvancedOptionsStateData {
  bool get isAntialiasingEnabled => throw _privateConstructorUsedError;
  bool get isSmoothingEnabled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdvancedOptionsStateDataCopyWith<AdvancedOptionsStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvancedOptionsStateDataCopyWith<$Res> {
  factory $AdvancedOptionsStateDataCopyWith(AdvancedOptionsStateData value,
          $Res Function(AdvancedOptionsStateData) then) =
      _$AdvancedOptionsStateDataCopyWithImpl<$Res, AdvancedOptionsStateData>;
  @useResult
  $Res call({bool isAntialiasingEnabled, bool isSmoothingEnabled});
}

/// @nodoc
class _$AdvancedOptionsStateDataCopyWithImpl<$Res,
        $Val extends AdvancedOptionsStateData>
    implements $AdvancedOptionsStateDataCopyWith<$Res> {
  _$AdvancedOptionsStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAntialiasingEnabled = null,
    Object? isSmoothingEnabled = null,
  }) {
    return _then(_value.copyWith(
      isAntialiasingEnabled: null == isAntialiasingEnabled
          ? _value.isAntialiasingEnabled
          : isAntialiasingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmoothingEnabled: null == isSmoothingEnabled
          ? _value.isSmoothingEnabled
          : isSmoothingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdvancedOptionsStateDataImplCopyWith<$Res>
    implements $AdvancedOptionsStateDataCopyWith<$Res> {
  factory _$$AdvancedOptionsStateDataImplCopyWith(
          _$AdvancedOptionsStateDataImpl value,
          $Res Function(_$AdvancedOptionsStateDataImpl) then) =
      __$$AdvancedOptionsStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isAntialiasingEnabled, bool isSmoothingEnabled});
}

/// @nodoc
class __$$AdvancedOptionsStateDataImplCopyWithImpl<$Res>
    extends _$AdvancedOptionsStateDataCopyWithImpl<$Res,
        _$AdvancedOptionsStateDataImpl>
    implements _$$AdvancedOptionsStateDataImplCopyWith<$Res> {
  __$$AdvancedOptionsStateDataImplCopyWithImpl(
      _$AdvancedOptionsStateDataImpl _value,
      $Res Function(_$AdvancedOptionsStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAntialiasingEnabled = null,
    Object? isSmoothingEnabled = null,
  }) {
    return _then(_$AdvancedOptionsStateDataImpl(
      isAntialiasingEnabled: null == isAntialiasingEnabled
          ? _value.isAntialiasingEnabled
          : isAntialiasingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmoothingEnabled: null == isSmoothingEnabled
          ? _value.isSmoothingEnabled
          : isSmoothingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AdvancedOptionsStateDataImpl implements _AdvancedOptionsStateData {
  const _$AdvancedOptionsStateDataImpl(
      {this.isAntialiasingEnabled = false, this.isSmoothingEnabled = false});

  @override
  @JsonKey()
  final bool isAntialiasingEnabled;
  @override
  @JsonKey()
  final bool isSmoothingEnabled;

  @override
  String toString() {
    return 'AdvancedOptionsStateData(isAntialiasingEnabled: $isAntialiasingEnabled, isSmoothingEnabled: $isSmoothingEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvancedOptionsStateDataImpl &&
            (identical(other.isAntialiasingEnabled, isAntialiasingEnabled) ||
                other.isAntialiasingEnabled == isAntialiasingEnabled) &&
            (identical(other.isSmoothingEnabled, isSmoothingEnabled) ||
                other.isSmoothingEnabled == isSmoothingEnabled));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isAntialiasingEnabled, isSmoothingEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdvancedOptionsStateDataImplCopyWith<_$AdvancedOptionsStateDataImpl>
      get copyWith => __$$AdvancedOptionsStateDataImplCopyWithImpl<
          _$AdvancedOptionsStateDataImpl>(this, _$identity);
}

abstract class _AdvancedOptionsStateData implements AdvancedOptionsStateData {
  const factory _AdvancedOptionsStateData(
      {final bool isAntialiasingEnabled,
      final bool isSmoothingEnabled}) = _$AdvancedOptionsStateDataImpl;

  @override
  bool get isAntialiasingEnabled;
  @override
  bool get isSmoothingEnabled;
  @override
  @JsonKey(ignore: true)
  _$$AdvancedOptionsStateDataImplCopyWith<_$AdvancedOptionsStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
