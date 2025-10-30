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
  ShapeType get shapeType => throw _privateConstructorUsedError;
  ShapeStyle get shapeStyle => throw _privateConstructorUsedError;

  /// Create a copy of ShapesToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
  $Res call({ShapeType shapeType, ShapeStyle shapeStyle});
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

  /// Create a copy of ShapesToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shapeType = null,
    Object? shapeStyle = null,
  }) {
    return _then(_value.copyWith(
      shapeType: null == shapeType
          ? _value.shapeType
          : shapeType // ignore: cast_nullable_to_non_nullable
              as ShapeType,
      shapeStyle: null == shapeStyle
          ? _value.shapeStyle
          : shapeStyle // ignore: cast_nullable_to_non_nullable
              as ShapeStyle,
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
  $Res call({ShapeType shapeType, ShapeStyle shapeStyle});
}

/// @nodoc
class __$$ShapesToolOptionsDataImplCopyWithImpl<$Res>
    extends _$ShapesToolOptionsStateDataCopyWithImpl<$Res,
        _$ShapesToolOptionsDataImpl>
    implements _$$ShapesToolOptionsDataImplCopyWith<$Res> {
  __$$ShapesToolOptionsDataImplCopyWithImpl(_$ShapesToolOptionsDataImpl _value,
      $Res Function(_$ShapesToolOptionsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShapesToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shapeType = null,
    Object? shapeStyle = null,
  }) {
    return _then(_$ShapesToolOptionsDataImpl(
      shapeType: null == shapeType
          ? _value.shapeType
          : shapeType // ignore: cast_nullable_to_non_nullable
              as ShapeType,
      shapeStyle: null == shapeStyle
          ? _value.shapeStyle
          : shapeStyle // ignore: cast_nullable_to_non_nullable
              as ShapeStyle,
    ));
  }
}

/// @nodoc

class _$ShapesToolOptionsDataImpl implements _ShapesToolOptionsData {
  const _$ShapesToolOptionsDataImpl(
      {required this.shapeType, required this.shapeStyle});

  @override
  final ShapeType shapeType;
  @override
  final ShapeStyle shapeStyle;

  @override
  String toString() {
    return 'ShapesToolOptionsStateData(shapeType: $shapeType, shapeStyle: $shapeStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShapesToolOptionsDataImpl &&
            (identical(other.shapeType, shapeType) ||
                other.shapeType == shapeType) &&
            (identical(other.shapeStyle, shapeStyle) ||
                other.shapeStyle == shapeStyle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shapeType, shapeStyle);

  /// Create a copy of ShapesToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShapesToolOptionsDataImplCopyWith<_$ShapesToolOptionsDataImpl>
      get copyWith => __$$ShapesToolOptionsDataImplCopyWithImpl<
          _$ShapesToolOptionsDataImpl>(this, _$identity);
}

abstract class _ShapesToolOptionsData implements ShapesToolOptionsStateData {
  const factory _ShapesToolOptionsData(
      {required final ShapeType shapeType,
      required final ShapeStyle shapeStyle}) = _$ShapesToolOptionsDataImpl;

  @override
  ShapeType get shapeType;
  @override
  ShapeStyle get shapeStyle;

  /// Create a copy of ShapesToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShapesToolOptionsDataImplCopyWith<_$ShapesToolOptionsDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
