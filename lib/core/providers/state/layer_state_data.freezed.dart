// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layer_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LayerStateData {
  ValueKey<dynamic> get key => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayerStateDataCopyWith<LayerStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerStateDataCopyWith<$Res> {
  factory $LayerStateDataCopyWith(
          LayerStateData value, $Res Function(LayerStateData) then) =
      _$LayerStateDataCopyWithImpl<$Res, LayerStateData>;
  @useResult
  $Res call(
      {ValueKey<dynamic> key, bool isSelected, bool isVisible, double opacity});
}

/// @nodoc
class _$LayerStateDataCopyWithImpl<$Res, $Val extends LayerStateData>
    implements $LayerStateDataCopyWith<$Res> {
  _$LayerStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? isSelected = null,
    Object? isVisible = null,
    Object? opacity = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as ValueKey<dynamic>,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LayerStateDataImplCopyWith<$Res>
    implements $LayerStateDataCopyWith<$Res> {
  factory _$$LayerStateDataImplCopyWith(_$LayerStateDataImpl value,
          $Res Function(_$LayerStateDataImpl) then) =
      __$$LayerStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ValueKey<dynamic> key, bool isSelected, bool isVisible, double opacity});
}

/// @nodoc
class __$$LayerStateDataImplCopyWithImpl<$Res>
    extends _$LayerStateDataCopyWithImpl<$Res, _$LayerStateDataImpl>
    implements _$$LayerStateDataImplCopyWith<$Res> {
  __$$LayerStateDataImplCopyWithImpl(
      _$LayerStateDataImpl _value, $Res Function(_$LayerStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? isSelected = null,
    Object? isVisible = null,
    Object? opacity = null,
  }) {
    return _then(_$LayerStateDataImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as ValueKey<dynamic>,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$LayerStateDataImpl implements _LayerStateData {
  const _$LayerStateDataImpl(
      {required this.key,
      required this.isSelected,
      required this.isVisible,
      required this.opacity});

  @override
  final ValueKey<dynamic> key;
  @override
  final bool isSelected;
  @override
  final bool isVisible;
  @override
  final double opacity;

  @override
  String toString() {
    return 'LayerStateData(key: $key, isSelected: $isSelected, isVisible: $isVisible, opacity: $opacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerStateDataImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.opacity, opacity) || other.opacity == opacity));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, key, isSelected, isVisible, opacity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerStateDataImplCopyWith<_$LayerStateDataImpl> get copyWith =>
      __$$LayerStateDataImplCopyWithImpl<_$LayerStateDataImpl>(
          this, _$identity);
}

abstract class _LayerStateData implements LayerStateData {
  const factory _LayerStateData(
      {required final ValueKey<dynamic> key,
      required final bool isSelected,
      required final bool isVisible,
      required final double opacity}) = _$LayerStateDataImpl;

  @override
  ValueKey<dynamic> get key;
  @override
  bool get isSelected;
  @override
  bool get isVisible;
  @override
  double get opacity;
  @override
  @JsonKey(ignore: true)
  _$$LayerStateDataImplCopyWith<_$LayerStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
