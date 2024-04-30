// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toolbox_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ToolBoxStateData {
  Tool get currentTool => throw _privateConstructorUsedError;
  ToolType get currentToolType => throw _privateConstructorUsedError;
  bool get isDown => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ToolBoxStateDataCopyWith<ToolBoxStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolBoxStateDataCopyWith<$Res> {
  factory $ToolBoxStateDataCopyWith(
          ToolBoxStateData value, $Res Function(ToolBoxStateData) then) =
      _$ToolBoxStateDataCopyWithImpl<$Res, ToolBoxStateData>;
  @useResult
  $Res call({Tool currentTool, ToolType currentToolType, bool isDown});
}

/// @nodoc
class _$ToolBoxStateDataCopyWithImpl<$Res, $Val extends ToolBoxStateData>
    implements $ToolBoxStateDataCopyWith<$Res> {
  _$ToolBoxStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTool = null,
    Object? currentToolType = null,
    Object? isDown = null,
  }) {
    return _then(_value.copyWith(
      currentTool: null == currentTool
          ? _value.currentTool
          : currentTool // ignore: cast_nullable_to_non_nullable
              as Tool,
      currentToolType: null == currentToolType
          ? _value.currentToolType
          : currentToolType // ignore: cast_nullable_to_non_nullable
              as ToolType,
      isDown: null == isDown
          ? _value.isDown
          : isDown // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ToolBoxStateDataCopyWith<$Res>
    implements $ToolBoxStateDataCopyWith<$Res> {
  factory _$$_ToolBoxStateDataCopyWith(
          _$_ToolBoxStateData value, $Res Function(_$_ToolBoxStateData) then) =
      __$$_ToolBoxStateDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Tool currentTool, ToolType currentToolType, bool isDown});
}

/// @nodoc
class __$$_ToolBoxStateDataCopyWithImpl<$Res>
    extends _$ToolBoxStateDataCopyWithImpl<$Res, _$_ToolBoxStateData>
    implements _$$_ToolBoxStateDataCopyWith<$Res> {
  __$$_ToolBoxStateDataCopyWithImpl(
      _$_ToolBoxStateData _value, $Res Function(_$_ToolBoxStateData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTool = null,
    Object? currentToolType = null,
    Object? isDown = null,
  }) {
    return _then(_$_ToolBoxStateData(
      currentTool: null == currentTool
          ? _value.currentTool
          : currentTool // ignore: cast_nullable_to_non_nullable
              as Tool,
      currentToolType: null == currentToolType
          ? _value.currentToolType
          : currentToolType // ignore: cast_nullable_to_non_nullable
              as ToolType,
      isDown: null == isDown
          ? _value.isDown
          : isDown // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ToolBoxStateData implements _ToolBoxStateData {
  const _$_ToolBoxStateData(
      {required this.currentTool,
      required this.currentToolType,
      required this.isDown});

  @override
  final Tool currentTool;
  @override
  final ToolType currentToolType;
  @override
  final bool isDown;

  @override
  String toString() {
    return 'ToolBoxStateData(currentTool: $currentTool, currentToolType: $currentToolType, isDown: $isDown)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ToolBoxStateData &&
            (identical(other.currentTool, currentTool) ||
                other.currentTool == currentTool) &&
            (identical(other.currentToolType, currentToolType) ||
                other.currentToolType == currentToolType) &&
            (identical(other.isDown, isDown) || other.isDown == isDown));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentTool, currentToolType, isDown);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ToolBoxStateDataCopyWith<_$_ToolBoxStateData> get copyWith =>
      __$$_ToolBoxStateDataCopyWithImpl<_$_ToolBoxStateData>(this, _$identity);
}

abstract class _ToolBoxStateData implements ToolBoxStateData {
  const factory _ToolBoxStateData(
      {required final Tool currentTool,
      required final ToolType currentToolType,
      required final bool isDown}) = _$_ToolBoxStateData;

  @override
  Tool get currentTool;
  @override
  ToolType get currentToolType;
  @override
  bool get isDown;
  @override
  @JsonKey(ignore: true)
  _$$_ToolBoxStateDataCopyWith<_$_ToolBoxStateData> get copyWith =>
      throw _privateConstructorUsedError;
}
