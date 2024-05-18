// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_picker_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ColorPickerStateData {
  Color get currentColor => throw _privateConstructorUsedError;
  double get currentOpacity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ColorPickerStateDataCopyWith<ColorPickerStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorPickerStateDataCopyWith<$Res> {
  factory $ColorPickerStateDataCopyWith(ColorPickerStateData value,
          $Res Function(ColorPickerStateData) then) =
      _$ColorPickerStateDataCopyWithImpl<$Res, ColorPickerStateData>;
  @useResult
  $Res call({Color currentColor, double currentOpacity});
}

/// @nodoc
class _$ColorPickerStateDataCopyWithImpl<$Res,
        $Val extends ColorPickerStateData>
    implements $ColorPickerStateDataCopyWith<$Res> {
  _$ColorPickerStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentColor = null,
    Object? currentOpacity = null,
  }) {
    return _then(_value.copyWith(
      currentColor: null == currentColor
          ? _value.currentColor
          : currentColor // ignore: cast_nullable_to_non_nullable
              as Color,
      currentOpacity: null == currentOpacity
          ? _value.currentOpacity
          : currentOpacity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ColorPickerStateDataCopyWith<$Res>
    implements $ColorPickerStateDataCopyWith<$Res> {
  factory _$$_ColorPickerStateDataCopyWith(_$_ColorPickerStateData value,
          $Res Function(_$_ColorPickerStateData) then) =
      __$$_ColorPickerStateDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Color currentColor, double currentOpacity});
}

/// @nodoc
class __$$_ColorPickerStateDataCopyWithImpl<$Res>
    extends _$ColorPickerStateDataCopyWithImpl<$Res, _$_ColorPickerStateData>
    implements _$$_ColorPickerStateDataCopyWith<$Res> {
  __$$_ColorPickerStateDataCopyWithImpl(_$_ColorPickerStateData _value,
      $Res Function(_$_ColorPickerStateData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentColor = null,
    Object? currentOpacity = null,
  }) {
    return _then(_$_ColorPickerStateData(
      currentColor: null == currentColor
          ? _value.currentColor
          : currentColor // ignore: cast_nullable_to_non_nullable
              as Color,
      currentOpacity: null == currentOpacity
          ? _value.currentOpacity
          : currentOpacity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_ColorPickerStateData implements _ColorPickerStateData {
  const _$_ColorPickerStateData(
      {required this.currentColor, required this.currentOpacity});

  @override
  final Color currentColor;
  @override
  final double currentOpacity;

  @override
  String toString() {
    return 'ColorPickerStateData(currentColor: $currentColor, currentOpacity: $currentOpacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ColorPickerStateData &&
            (identical(other.currentColor, currentColor) ||
                other.currentColor == currentColor) &&
            (identical(other.currentOpacity, currentOpacity) ||
                other.currentOpacity == currentOpacity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentColor, currentOpacity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ColorPickerStateDataCopyWith<_$_ColorPickerStateData> get copyWith =>
      __$$_ColorPickerStateDataCopyWithImpl<_$_ColorPickerStateData>(
          this, _$identity);
}

abstract class _ColorPickerStateData implements ColorPickerStateData {
  const factory _ColorPickerStateData(
      {required final Color currentColor,
      required final double currentOpacity}) = _$_ColorPickerStateData;

  @override
  Color get currentColor;
  @override
  double get currentOpacity;
  @override
  @JsonKey(ignore: true)
  _$$_ColorPickerStateDataCopyWith<_$_ColorPickerStateData> get copyWith =>
      throw _privateConstructorUsedError;
}
