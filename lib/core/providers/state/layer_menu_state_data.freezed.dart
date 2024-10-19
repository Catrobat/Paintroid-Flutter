// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layer_menu_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LayerMenuStateData {
  bool get isVisible => throw _privateConstructorUsedError;
  List<LayerStateData> get layers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayerMenuStateDataCopyWith<LayerMenuStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerMenuStateDataCopyWith<$Res> {
  factory $LayerMenuStateDataCopyWith(
          LayerMenuStateData value, $Res Function(LayerMenuStateData) then) =
      _$LayerMenuStateDataCopyWithImpl<$Res, LayerMenuStateData>;
  @useResult
  $Res call({bool isVisible, List<LayerStateData> layers});
}

/// @nodoc
class _$LayerMenuStateDataCopyWithImpl<$Res, $Val extends LayerMenuStateData>
    implements $LayerMenuStateDataCopyWith<$Res> {
  _$LayerMenuStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
    Object? layers = null,
  }) {
    return _then(_value.copyWith(
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      layers: null == layers
          ? _value.layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<LayerStateData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LayerMenuStateDataImplCopyWith<$Res>
    implements $LayerMenuStateDataCopyWith<$Res> {
  factory _$$LayerMenuStateDataImplCopyWith(_$LayerMenuStateDataImpl value,
          $Res Function(_$LayerMenuStateDataImpl) then) =
      __$$LayerMenuStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isVisible, List<LayerStateData> layers});
}

/// @nodoc
class __$$LayerMenuStateDataImplCopyWithImpl<$Res>
    extends _$LayerMenuStateDataCopyWithImpl<$Res, _$LayerMenuStateDataImpl>
    implements _$$LayerMenuStateDataImplCopyWith<$Res> {
  __$$LayerMenuStateDataImplCopyWithImpl(_$LayerMenuStateDataImpl _value,
      $Res Function(_$LayerMenuStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
    Object? layers = null,
  }) {
    return _then(_$LayerMenuStateDataImpl(
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      layers: null == layers
          ? _value._layers
          : layers // ignore: cast_nullable_to_non_nullable
              as List<LayerStateData>,
    ));
  }
}

/// @nodoc

class _$LayerMenuStateDataImpl implements _LayerMenuStateData {
  const _$LayerMenuStateDataImpl(
      {required this.isVisible, required final List<LayerStateData> layers})
      : _layers = layers;

  @override
  final bool isVisible;
  final List<LayerStateData> _layers;
  @override
  List<LayerStateData> get layers {
    if (_layers is EqualUnmodifiableListView) return _layers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layers);
  }

  @override
  String toString() {
    return 'LayerMenuStateData(isVisible: $isVisible, layers: $layers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerMenuStateDataImpl &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            const DeepCollectionEquality().equals(other._layers, _layers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isVisible, const DeepCollectionEquality().hash(_layers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerMenuStateDataImplCopyWith<_$LayerMenuStateDataImpl> get copyWith =>
      __$$LayerMenuStateDataImplCopyWithImpl<_$LayerMenuStateDataImpl>(
          this, _$identity);
}

abstract class _LayerMenuStateData implements LayerMenuStateData {
  const factory _LayerMenuStateData(
      {required final bool isVisible,
      required final List<LayerStateData> layers}) = _$LayerMenuStateDataImpl;

  @override
  bool get isVisible;
  @override
  List<LayerStateData> get layers;
  @override
  @JsonKey(ignore: true)
  _$$LayerMenuStateDataImplCopyWith<_$LayerMenuStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
