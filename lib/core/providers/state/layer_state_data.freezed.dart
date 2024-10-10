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
  int get id => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

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
  $Res call({int id, bool isSelected});
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
    Object? id = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
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
  $Res call({int id, bool isSelected});
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
    Object? id = null,
    Object? isSelected = null,
  }) {
    return _then(_$LayerStateDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LayerStateDataImpl implements _LayerStateData {
  const _$LayerStateDataImpl({required this.id, required this.isSelected});

  @override
  final int id;
  @override
  final bool isSelected;

  @override
  String toString() {
    return 'LayerStateData(id: $id, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerStateDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, isSelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerStateDataImplCopyWith<_$LayerStateDataImpl> get copyWith =>
      __$$LayerStateDataImplCopyWithImpl<_$LayerStateDataImpl>(
          this, _$identity);
}

abstract class _LayerStateData implements LayerStateData {
  const factory _LayerStateData(
      {required final int id,
      required final bool isSelected}) = _$LayerStateDataImpl;

  @override
  int get id;
  @override
  bool get isSelected;
  @override
  @JsonKey(ignore: true)
  _$$LayerStateDataImplCopyWith<_$LayerStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
