// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkspaceState {
  bool get isFullscreen => throw _privateConstructorUsedError;
  bool get isPerformingIOTask => throw _privateConstructorUsedError;
  bool get hasUnsavedChanges => throw _privateConstructorUsedError;
  int get commandCountWhenLastSaved => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkspaceStateCopyWith<WorkspaceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceStateCopyWith<$Res> {
  factory $WorkspaceStateCopyWith(
          WorkspaceState value, $Res Function(WorkspaceState) then) =
      _$WorkspaceStateCopyWithImpl<$Res, WorkspaceState>;
  @useResult
  $Res call(
      {bool isFullscreen,
      bool isPerformingIOTask,
      bool hasUnsavedChanges,
      int commandCountWhenLastSaved});
}

/// @nodoc
class _$WorkspaceStateCopyWithImpl<$Res, $Val extends WorkspaceState>
    implements $WorkspaceStateCopyWith<$Res> {
  _$WorkspaceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFullscreen = null,
    Object? isPerformingIOTask = null,
    Object? hasUnsavedChanges = null,
    Object? commandCountWhenLastSaved = null,
  }) {
    return _then(_value.copyWith(
      isFullscreen: null == isFullscreen
          ? _value.isFullscreen
          : isFullscreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isPerformingIOTask: null == isPerformingIOTask
          ? _value.isPerformingIOTask
          : isPerformingIOTask // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUnsavedChanges: null == hasUnsavedChanges
          ? _value.hasUnsavedChanges
          : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      commandCountWhenLastSaved: null == commandCountWhenLastSaved
          ? _value.commandCountWhenLastSaved
          : commandCountWhenLastSaved // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkspaceStateImplCopyWith<$Res>
    implements $WorkspaceStateCopyWith<$Res> {
  factory _$$WorkspaceStateImplCopyWith(_$WorkspaceStateImpl value,
          $Res Function(_$WorkspaceStateImpl) then) =
      __$$WorkspaceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isFullscreen,
      bool isPerformingIOTask,
      bool hasUnsavedChanges,
      int commandCountWhenLastSaved});
}

/// @nodoc
class __$$WorkspaceStateImplCopyWithImpl<$Res>
    extends _$WorkspaceStateCopyWithImpl<$Res, _$WorkspaceStateImpl>
    implements _$$WorkspaceStateImplCopyWith<$Res> {
  __$$WorkspaceStateImplCopyWithImpl(
      _$WorkspaceStateImpl _value, $Res Function(_$WorkspaceStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFullscreen = null,
    Object? isPerformingIOTask = null,
    Object? hasUnsavedChanges = null,
    Object? commandCountWhenLastSaved = null,
  }) {
    return _then(_$WorkspaceStateImpl(
      isFullscreen: null == isFullscreen
          ? _value.isFullscreen
          : isFullscreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isPerformingIOTask: null == isPerformingIOTask
          ? _value.isPerformingIOTask
          : isPerformingIOTask // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUnsavedChanges: null == hasUnsavedChanges
          ? _value.hasUnsavedChanges
          : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      commandCountWhenLastSaved: null == commandCountWhenLastSaved
          ? _value.commandCountWhenLastSaved
          : commandCountWhenLastSaved // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WorkspaceStateImpl implements _WorkspaceState {
  const _$WorkspaceStateImpl(
      {required this.isFullscreen,
      required this.isPerformingIOTask,
      required this.hasUnsavedChanges,
      required this.commandCountWhenLastSaved});

  @override
  final bool isFullscreen;
  @override
  final bool isPerformingIOTask;
  @override
  final bool hasUnsavedChanges;
  @override
  final int commandCountWhenLastSaved;

  @override
  String toString() {
    return 'WorkspaceState(isFullscreen: $isFullscreen, isPerformingIOTask: $isPerformingIOTask, hasUnsavedChanges: $hasUnsavedChanges, commandCountWhenLastSaved: $commandCountWhenLastSaved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceStateImpl &&
            (identical(other.isFullscreen, isFullscreen) ||
                other.isFullscreen == isFullscreen) &&
            (identical(other.isPerformingIOTask, isPerformingIOTask) ||
                other.isPerformingIOTask == isPerformingIOTask) &&
            (identical(other.hasUnsavedChanges, hasUnsavedChanges) ||
                other.hasUnsavedChanges == hasUnsavedChanges) &&
            (identical(other.commandCountWhenLastSaved,
                    commandCountWhenLastSaved) ||
                other.commandCountWhenLastSaved == commandCountWhenLastSaved));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isFullscreen, isPerformingIOTask,
      hasUnsavedChanges, commandCountWhenLastSaved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceStateImplCopyWith<_$WorkspaceStateImpl> get copyWith =>
      __$$WorkspaceStateImplCopyWithImpl<_$WorkspaceStateImpl>(
          this, _$identity);
}

abstract class _WorkspaceState implements WorkspaceState {
  const factory _WorkspaceState(
      {required final bool isFullscreen,
      required final bool isPerformingIOTask,
      required final bool hasUnsavedChanges,
      required final int commandCountWhenLastSaved}) = _$WorkspaceStateImpl;

  @override
  bool get isFullscreen;
  @override
  bool get isPerformingIOTask;
  @override
  bool get hasUnsavedChanges;
  @override
  int get commandCountWhenLastSaved;
  @override
  @JsonKey(ignore: true)
  _$$WorkspaceStateImplCopyWith<_$WorkspaceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
