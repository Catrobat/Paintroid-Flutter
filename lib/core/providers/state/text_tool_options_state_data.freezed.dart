// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_tool_options_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TextToolOptionsStateData {
  String get text => throw _privateConstructorUsedError;
  double get fontSize => throw _privateConstructorUsedError;
  bool get isAutoSize => throw _privateConstructorUsedError;
  bool get isBold => throw _privateConstructorUsedError;
  bool get isItalic => throw _privateConstructorUsedError;
  bool get isUnderline => throw _privateConstructorUsedError;
  String get fontFamily => throw _privateConstructorUsedError;

  /// Create a copy of TextToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextToolOptionsStateDataCopyWith<TextToolOptionsStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextToolOptionsStateDataCopyWith<$Res> {
  factory $TextToolOptionsStateDataCopyWith(TextToolOptionsStateData value,
          $Res Function(TextToolOptionsStateData) then) =
      _$TextToolOptionsStateDataCopyWithImpl<$Res, TextToolOptionsStateData>;
  @useResult
  $Res call(
      {String text,
      double fontSize,
      bool isAutoSize,
      bool isBold,
      bool isItalic,
      bool isUnderline,
      String fontFamily});
}

/// @nodoc
class _$TextToolOptionsStateDataCopyWithImpl<$Res,
        $Val extends TextToolOptionsStateData>
    implements $TextToolOptionsStateDataCopyWith<$Res> {
  _$TextToolOptionsStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? fontSize = null,
    Object? isAutoSize = null,
    Object? isBold = null,
    Object? isItalic = null,
    Object? isUnderline = null,
    Object? fontFamily = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      isAutoSize: null == isAutoSize
          ? _value.isAutoSize
          : isAutoSize // ignore: cast_nullable_to_non_nullable
              as bool,
      isBold: null == isBold
          ? _value.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
      isItalic: null == isItalic
          ? _value.isItalic
          : isItalic // ignore: cast_nullable_to_non_nullable
              as bool,
      isUnderline: null == isUnderline
          ? _value.isUnderline
          : isUnderline // ignore: cast_nullable_to_non_nullable
              as bool,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextToolOptionsStateDataImplCopyWith<$Res>
    implements $TextToolOptionsStateDataCopyWith<$Res> {
  factory _$$TextToolOptionsStateDataImplCopyWith(
          _$TextToolOptionsStateDataImpl value,
          $Res Function(_$TextToolOptionsStateDataImpl) then) =
      __$$TextToolOptionsStateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String text,
      double fontSize,
      bool isAutoSize,
      bool isBold,
      bool isItalic,
      bool isUnderline,
      String fontFamily});
}

/// @nodoc
class __$$TextToolOptionsStateDataImplCopyWithImpl<$Res>
    extends _$TextToolOptionsStateDataCopyWithImpl<$Res,
        _$TextToolOptionsStateDataImpl>
    implements _$$TextToolOptionsStateDataImplCopyWith<$Res> {
  __$$TextToolOptionsStateDataImplCopyWithImpl(
      _$TextToolOptionsStateDataImpl _value,
      $Res Function(_$TextToolOptionsStateDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of TextToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? fontSize = null,
    Object? isAutoSize = null,
    Object? isBold = null,
    Object? isItalic = null,
    Object? isUnderline = null,
    Object? fontFamily = null,
  }) {
    return _then(_$TextToolOptionsStateDataImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      isAutoSize: null == isAutoSize
          ? _value.isAutoSize
          : isAutoSize // ignore: cast_nullable_to_non_nullable
              as bool,
      isBold: null == isBold
          ? _value.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
      isItalic: null == isItalic
          ? _value.isItalic
          : isItalic // ignore: cast_nullable_to_non_nullable
              as bool,
      isUnderline: null == isUnderline
          ? _value.isUnderline
          : isUnderline // ignore: cast_nullable_to_non_nullable
              as bool,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TextToolOptionsStateDataImpl implements _TextToolOptionsStateData {
  const _$TextToolOptionsStateDataImpl(
      {this.text = 'Enter Text',
      this.fontSize = 30.0,
      this.isAutoSize = true,
      this.isBold = false,
      this.isItalic = false,
      this.isUnderline = false,
      this.fontFamily = 'Roboto'});

  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final double fontSize;
  @override
  @JsonKey()
  final bool isAutoSize;
  @override
  @JsonKey()
  final bool isBold;
  @override
  @JsonKey()
  final bool isItalic;
  @override
  @JsonKey()
  final bool isUnderline;
  @override
  @JsonKey()
  final String fontFamily;

  @override
  String toString() {
    return 'TextToolOptionsStateData(text: $text, fontSize: $fontSize, isAutoSize: $isAutoSize, isBold: $isBold, isItalic: $isItalic, isUnderline: $isUnderline, fontFamily: $fontFamily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextToolOptionsStateDataImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.isAutoSize, isAutoSize) ||
                other.isAutoSize == isAutoSize) &&
            (identical(other.isBold, isBold) || other.isBold == isBold) &&
            (identical(other.isItalic, isItalic) ||
                other.isItalic == isItalic) &&
            (identical(other.isUnderline, isUnderline) ||
                other.isUnderline == isUnderline) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, fontSize, isAutoSize,
      isBold, isItalic, isUnderline, fontFamily);

  /// Create a copy of TextToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextToolOptionsStateDataImplCopyWith<_$TextToolOptionsStateDataImpl>
      get copyWith => __$$TextToolOptionsStateDataImplCopyWithImpl<
          _$TextToolOptionsStateDataImpl>(this, _$identity);
}

abstract class _TextToolOptionsStateData implements TextToolOptionsStateData {
  const factory _TextToolOptionsStateData(
      {final String text,
      final double fontSize,
      final bool isAutoSize,
      final bool isBold,
      final bool isItalic,
      final bool isUnderline,
      final String fontFamily}) = _$TextToolOptionsStateDataImpl;

  @override
  String get text;
  @override
  double get fontSize;
  @override
  bool get isAutoSize;
  @override
  bool get isBold;
  @override
  bool get isItalic;
  @override
  bool get isUnderline;
  @override
  String get fontFamily;

  /// Create a copy of TextToolOptionsStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextToolOptionsStateDataImplCopyWith<_$TextToolOptionsStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
