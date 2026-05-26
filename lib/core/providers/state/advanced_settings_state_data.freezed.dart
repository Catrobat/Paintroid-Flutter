// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_settings_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdvancedSettingsStateData {
  bool get isAntialiasingEnabled => throw _privateConstructorUsedError;
  bool get isSmoothingEnabled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdvancedSettingsStateDataCopyWith<AdvancedSettingsStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvancedSettingsStateDataCopyWith<$Res> {
  factory $AdvancedSettingsStateDataCopyWith(AdvancedSettingsStateData value,
          $Res Function(AdvancedSettingsStateData) then) =
      _$AdvancedSettingsStateDataCopyWithImpl<$Res, AdvancedSettingsStateData>;
  @useResult
  $Res call({bool isAntialiasingEnabled, bool isSmoothingEnabled});
}

/// @nodoc
class _$AdvancedSettingsStateDataCopyWithImpl<$Res,
        $Val extends AdvancedSettingsStateData>
    implements $AdvancedSettingsStateDataCopyWith<$Res> {
  _$AdvancedSettingsStateDataCopyWithImpl(this._value, this._then);

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
abstract class _$$AdvancedSettingsStateDataImplCopyWith<$Res>
    implements $AdvancedSettingsStateDataCopyWith<$Res> {
  factory _$$AdvancedSettingsStateDataImplCopyWith(
          _$AdvancedSettingsStateDataImpl value,
          $Res Function(_$AdvancedSettingsStateDataImpl) then) =
      __$$AdvancedSettingsStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isAntialiasingEnabled, bool isSmoothingEnabled});
}

/// @nodoc
class __$$AdvancedSettingsStateDataImplCopyWithImpl<$Res>
    extends _$AdvancedSettingsStateDataCopyWithImpl<$Res,
        _$AdvancedSettingsStateDataImpl>
    implements _$$AdvancedSettingsStateDataImplCopyWith<$Res> {
  __$$AdvancedSettingsStateDataImplCopyWithImpl(
      _$AdvancedSettingsStateDataImpl _value,
      $Res Function(_$AdvancedSettingsStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAntialiasingEnabled = null,
    Object? isSmoothingEnabled = null,
  }) {
    return _then(_$AdvancedSettingsStateDataImpl(
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

class _$AdvancedSettingsStateDataImpl implements _AdvancedSettingsStateData {
  const _$AdvancedSettingsStateDataImpl(
      {this.isAntialiasingEnabled = false, this.isSmoothingEnabled = false});

  @override
  @JsonKey()
  final bool isAntialiasingEnabled;
  @override
  @JsonKey()
  final bool isSmoothingEnabled;

  @override
  String toString() {
    return 'AdvancedSettingsStateData(isAntialiasingEnabled: $isAntialiasingEnabled, isSmoothingEnabled: $isSmoothingEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvancedSettingsStateDataImpl &&
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
  _$$AdvancedSettingsStateDataImplCopyWith<_$AdvancedSettingsStateDataImpl>
      get copyWith => __$$AdvancedSettingsStateDataImplCopyWithImpl<
          _$AdvancedSettingsStateDataImpl>(this, _$identity);
}

abstract class _AdvancedSettingsStateData implements AdvancedSettingsStateData {
  const factory _AdvancedSettingsStateData(
      {final bool isAntialiasingEnabled,
      final bool isSmoothingEnabled}) = _$AdvancedSettingsStateDataImpl;

  @override
  bool get isAntialiasingEnabled;
  @override
  bool get isSmoothingEnabled;
  @override
  @JsonKey(ignore: true)
  _$$AdvancedSettingsStateDataImplCopyWith<_$AdvancedSettingsStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
