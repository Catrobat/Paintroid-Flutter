// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shapes_tool_options_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShapesToolOptionsStateData {
  bool get isRotating => throw _privateConstructorUsedError;
  ShapeType get shapeType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShapesToolOptionsStateDataCopyWith<ShapesToolOptionsStateData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShapesToolOptionsStateDataCopyWith<$Res> {
  factory $ShapesToolOptionsStateDataCopyWith(ShapesToolOptionsStateData value,
          $Res Function(ShapesToolOptionsStateData) then) =
      _$ShapesToolOptionsStateDataCopyWithImpl<$Res,
          ShapesToolOptionsStateData>;
  @useResult
  $Res call({bool isRotating, ShapeType shapeType});
}

/// @nodoc
class _$ShapesToolOptionsStateDataCopyWithImpl<$Res,
        $Val extends ShapesToolOptionsStateData>
    implements $ShapesToolOptionsStateDataCopyWith<$Res> {
  _$ShapesToolOptionsStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRotating = null,
    Object? shapeType = null,
  }) {
    return _then(_value.copyWith(
      isRotating: null == isRotating
          ? _value.isRotating
          : isRotating // ignore: cast_nullable_to_non_nullable
              as bool,
      shapeType: null == shapeType
          ? _value.shapeType
          : shapeType // ignore: cast_nullable_to_non_nullable
              as ShapeType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShapesToolOptionsDataImplCopyWith<$Res>
    implements $ShapesToolOptionsStateDataCopyWith<$Res> {
  factory _$$ShapesToolOptionsDataImplCopyWith(
          _$ShapesToolOptionsDataImpl value,
          $Res Function(_$ShapesToolOptionsDataImpl) then) =
      __$$ShapesToolOptionsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRotating, ShapeType shapeType});
}

/// @nodoc
class __$$ShapesToolOptionsDataImplCopyWithImpl<$Res>
    extends _$ShapesToolOptionsStateDataCopyWithImpl<$Res,
        _$ShapesToolOptionsDataImpl>
    implements _$$ShapesToolOptionsDataImplCopyWith<$Res> {
  __$$ShapesToolOptionsDataImplCopyWithImpl(_$ShapesToolOptionsDataImpl _value,
      $Res Function(_$ShapesToolOptionsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRotating = null,
    Object? shapeType = null,
  }) {
    return _then(_$ShapesToolOptionsDataImpl(
      isRotating: null == isRotating
          ? _value.isRotating
          : isRotating // ignore: cast_nullable_to_non_nullable
              as bool,
      shapeType: null == shapeType
          ? _value.shapeType
          : shapeType // ignore: cast_nullable_to_non_nullable
              as ShapeType,
    ));
  }
}

/// @nodoc

class _$ShapesToolOptionsDataImpl implements _ShapesToolOptionsData {
  const _$ShapesToolOptionsDataImpl(
      {required this.isRotating, required this.shapeType});

  @override
  final bool isRotating;
  @override
  final ShapeType shapeType;

  @override
  String toString() {
    return 'ShapesToolOptionsStateData(isRotating: $isRotating, shapeType: $shapeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShapesToolOptionsDataImpl &&
            (identical(other.isRotating, isRotating) ||
                other.isRotating == isRotating) &&
            (identical(other.shapeType, shapeType) ||
                other.shapeType == shapeType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRotating, shapeType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShapesToolOptionsDataImplCopyWith<_$ShapesToolOptionsDataImpl>
      get copyWith => __$$ShapesToolOptionsDataImplCopyWithImpl<
          _$ShapesToolOptionsDataImpl>(this, _$identity);
}

abstract class _ShapesToolOptionsData implements ShapesToolOptionsStateData {
  const factory _ShapesToolOptionsData(
      {required final bool isRotating,
      required final ShapeType shapeType}) = _$ShapesToolOptionsDataImpl;

  @override
  bool get isRotating;
  @override
  ShapeType get shapeType;
  @override
  @JsonKey(ignore: true)
  _$$ShapesToolOptionsDataImplCopyWith<_$ShapesToolOptionsDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
