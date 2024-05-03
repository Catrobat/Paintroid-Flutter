// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CanvasStateData {
  ui.Image? get backgroundImage => throw _privateConstructorUsedError;
  ui.Image? get cachedImage => throw _privateConstructorUsedError;
  ui.Size get size => throw _privateConstructorUsedError;
  CommandManager get commandManager => throw _privateConstructorUsedError;
  GraphicFactory get graphicFactory => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CanvasStateDataCopyWith<CanvasStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanvasStateDataCopyWith<$Res> {
  factory $CanvasStateDataCopyWith(
          CanvasStateData value, $Res Function(CanvasStateData) then) =
      _$CanvasStateDataCopyWithImpl<$Res, CanvasStateData>;
  @useResult
  $Res call(
      {ui.Image? backgroundImage,
      ui.Image? cachedImage,
      ui.Size size,
      CommandManager commandManager,
      GraphicFactory graphicFactory});
}

/// @nodoc
class _$CanvasStateDataCopyWithImpl<$Res, $Val extends CanvasStateData>
    implements $CanvasStateDataCopyWith<$Res> {
  _$CanvasStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundImage = freezed,
    Object? cachedImage = freezed,
    Object? size = null,
    Object? commandManager = null,
    Object? graphicFactory = null,
  }) {
    return _then(_value.copyWith(
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
      cachedImage: freezed == cachedImage
          ? _value.cachedImage
          : cachedImage // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as ui.Size,
      commandManager: null == commandManager
          ? _value.commandManager
          : commandManager // ignore: cast_nullable_to_non_nullable
              as CommandManager,
      graphicFactory: null == graphicFactory
          ? _value.graphicFactory
          : graphicFactory // ignore: cast_nullable_to_non_nullable
              as GraphicFactory,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CanvasStateDataImplCopyWith<$Res>
    implements $CanvasStateDataCopyWith<$Res> {
  factory _$$CanvasStateDataImplCopyWith(_$CanvasStateDataImpl value,
          $Res Function(_$CanvasStateDataImpl) then) =
      __$$CanvasStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ui.Image? backgroundImage,
      ui.Image? cachedImage,
      ui.Size size,
      CommandManager commandManager,
      GraphicFactory graphicFactory});
}

/// @nodoc
class __$$CanvasStateDataImplCopyWithImpl<$Res>
    extends _$CanvasStateDataCopyWithImpl<$Res, _$CanvasStateDataImpl>
    implements _$$CanvasStateDataImplCopyWith<$Res> {
  __$$CanvasStateDataImplCopyWithImpl(
      _$CanvasStateDataImpl _value, $Res Function(_$CanvasStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundImage = freezed,
    Object? cachedImage = freezed,
    Object? size = null,
    Object? commandManager = null,
    Object? graphicFactory = null,
  }) {
    return _then(_$CanvasStateDataImpl(
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
      cachedImage: freezed == cachedImage
          ? _value.cachedImage
          : cachedImage // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as ui.Size,
      commandManager: null == commandManager
          ? _value.commandManager
          : commandManager // ignore: cast_nullable_to_non_nullable
              as CommandManager,
      graphicFactory: null == graphicFactory
          ? _value.graphicFactory
          : graphicFactory // ignore: cast_nullable_to_non_nullable
              as GraphicFactory,
    ));
  }
}

/// @nodoc

class _$CanvasStateDataImpl implements _CanvasStateData {
  const _$CanvasStateDataImpl(
      {this.backgroundImage,
      this.cachedImage,
      required this.size,
      required this.commandManager,
      required this.graphicFactory});

  @override
  final ui.Image? backgroundImage;
  @override
  final ui.Image? cachedImage;
  @override
  final ui.Size size;
  @override
  final CommandManager commandManager;
  @override
  final GraphicFactory graphicFactory;

  @override
  String toString() {
    return 'CanvasStateData(backgroundImage: $backgroundImage, cachedImage: $cachedImage, size: $size, commandManager: $commandManager, graphicFactory: $graphicFactory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanvasStateDataImpl &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.cachedImage, cachedImage) ||
                other.cachedImage == cachedImage) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.commandManager, commandManager) ||
                other.commandManager == commandManager) &&
            (identical(other.graphicFactory, graphicFactory) ||
                other.graphicFactory == graphicFactory));
  }

  @override
  int get hashCode => Object.hash(runtimeType, backgroundImage, cachedImage,
      size, commandManager, graphicFactory);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CanvasStateDataImplCopyWith<_$CanvasStateDataImpl> get copyWith =>
      __$$CanvasStateDataImplCopyWithImpl<_$CanvasStateDataImpl>(
          this, _$identity);
}

abstract class _CanvasStateData implements CanvasStateData {
  const factory _CanvasStateData(
      {final ui.Image? backgroundImage,
      final ui.Image? cachedImage,
      required final ui.Size size,
      required final CommandManager commandManager,
      required final GraphicFactory graphicFactory}) = _$CanvasStateDataImpl;

  @override
  ui.Image? get backgroundImage;
  @override
  ui.Image? get cachedImage;
  @override
  ui.Size get size;
  @override
  CommandManager get commandManager;
  @override
  GraphicFactory get graphicFactory;
  @override
  @JsonKey(ignore: true)
  _$$CanvasStateDataImplCopyWith<_$CanvasStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
