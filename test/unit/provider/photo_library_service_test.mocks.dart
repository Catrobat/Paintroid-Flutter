// Mocks generated by Mockito 5.4.4 from annotations
// in paintroid/test/unit/provider/photo_library_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:convert' as _i9;
import 'dart:typed_data' as _i10;

import 'package:flutter/src/services/binary_messenger.dart' as _i4;
import 'package:flutter/src/services/message_codec.dart' as _i3;
import 'package:flutter/src/services/platform_channel.dart' as _i7;
import 'package:image_picker/image_picker.dart' as _i5;
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLostData_0 extends _i1.SmartFake implements _i2.LostData {
  _FakeLostData_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLostDataResponse_1 extends _i1.SmartFake
    implements _i2.LostDataResponse {
  _FakeLostDataResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMethodCodec_2 extends _i1.SmartFake implements _i3.MethodCodec {
  _FakeMethodCodec_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBinaryMessenger_3 extends _i1.SmartFake
    implements _i4.BinaryMessenger {
  _FakeBinaryMessenger_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_4 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ImagePicker].
///
/// See the documentation for Mockito's code generation for more information.
class MockImagePicker extends _i1.Mock implements _i5.ImagePicker {
  MockImagePicker() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.PickedFile?> getImage({
    required _i2.ImageSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    _i2.CameraDevice? preferredCameraDevice = _i2.CameraDevice.rear,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getImage,
          [],
          {
            #source: source,
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #preferredCameraDevice: preferredCameraDevice,
          },
        ),
        returnValue: _i6.Future<_i2.PickedFile?>.value(),
      ) as _i6.Future<_i2.PickedFile?>);

  @override
  _i6.Future<List<_i2.PickedFile>?> getMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMultiImage,
          [],
          {
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
          },
        ),
        returnValue: _i6.Future<List<_i2.PickedFile>?>.value(),
      ) as _i6.Future<List<_i2.PickedFile>?>);

  @override
  _i6.Future<_i2.PickedFile?> getVideo({
    required _i2.ImageSource? source,
    _i2.CameraDevice? preferredCameraDevice = _i2.CameraDevice.rear,
    Duration? maxDuration,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getVideo,
          [],
          {
            #source: source,
            #preferredCameraDevice: preferredCameraDevice,
            #maxDuration: maxDuration,
          },
        ),
        returnValue: _i6.Future<_i2.PickedFile?>.value(),
      ) as _i6.Future<_i2.PickedFile?>);

  @override
  _i6.Future<_i2.LostData> getLostData() => (super.noSuchMethod(
        Invocation.method(
          #getLostData,
          [],
        ),
        returnValue: _i6.Future<_i2.LostData>.value(_FakeLostData_0(
          this,
          Invocation.method(
            #getLostData,
            [],
          ),
        )),
      ) as _i6.Future<_i2.LostData>);

  @override
  _i6.Future<_i2.XFile?> pickImage({
    required _i2.ImageSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    _i2.CameraDevice? preferredCameraDevice = _i2.CameraDevice.rear,
    bool? requestFullMetadata = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pickImage,
          [],
          {
            #source: source,
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #preferredCameraDevice: preferredCameraDevice,
            #requestFullMetadata: requestFullMetadata,
          },
        ),
        returnValue: _i6.Future<_i2.XFile?>.value(),
      ) as _i6.Future<_i2.XFile?>);

  @override
  _i6.Future<List<_i2.XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool? requestFullMetadata = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pickMultiImage,
          [],
          {
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #requestFullMetadata: requestFullMetadata,
          },
        ),
        returnValue: _i6.Future<List<_i2.XFile>>.value(<_i2.XFile>[]),
      ) as _i6.Future<List<_i2.XFile>>);

  @override
  _i6.Future<_i2.XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool? requestFullMetadata = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pickMedia,
          [],
          {
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #requestFullMetadata: requestFullMetadata,
          },
        ),
        returnValue: _i6.Future<_i2.XFile?>.value(),
      ) as _i6.Future<_i2.XFile?>);

  @override
  _i6.Future<List<_i2.XFile>> pickMultipleMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool? requestFullMetadata = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pickMultipleMedia,
          [],
          {
            #maxWidth: maxWidth,
            #maxHeight: maxHeight,
            #imageQuality: imageQuality,
            #requestFullMetadata: requestFullMetadata,
          },
        ),
        returnValue: _i6.Future<List<_i2.XFile>>.value(<_i2.XFile>[]),
      ) as _i6.Future<List<_i2.XFile>>);

  @override
  _i6.Future<_i2.XFile?> pickVideo({
    required _i2.ImageSource? source,
    _i2.CameraDevice? preferredCameraDevice = _i2.CameraDevice.rear,
    Duration? maxDuration,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pickVideo,
          [],
          {
            #source: source,
            #preferredCameraDevice: preferredCameraDevice,
            #maxDuration: maxDuration,
          },
        ),
        returnValue: _i6.Future<_i2.XFile?>.value(),
      ) as _i6.Future<_i2.XFile?>);

  @override
  _i6.Future<_i2.LostDataResponse> retrieveLostData() => (super.noSuchMethod(
        Invocation.method(
          #retrieveLostData,
          [],
        ),
        returnValue:
            _i6.Future<_i2.LostDataResponse>.value(_FakeLostDataResponse_1(
          this,
          Invocation.method(
            #retrieveLostData,
            [],
          ),
        )),
      ) as _i6.Future<_i2.LostDataResponse>);

  @override
  bool supportsImageSource(_i2.ImageSource? source) => (super.noSuchMethod(
        Invocation.method(
          #supportsImageSource,
          [source],
        ),
        returnValue: false,
      ) as bool);
}

/// A class which mocks [MethodChannel].
///
/// See the documentation for Mockito's code generation for more information.
class MockMethodChannel extends _i1.Mock implements _i7.MethodChannel {
  MockMethodChannel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  _i3.MethodCodec get codec => (super.noSuchMethod(
        Invocation.getter(#codec),
        returnValue: _FakeMethodCodec_2(
          this,
          Invocation.getter(#codec),
        ),
      ) as _i3.MethodCodec);

  @override
  _i4.BinaryMessenger get binaryMessenger => (super.noSuchMethod(
        Invocation.getter(#binaryMessenger),
        returnValue: _FakeBinaryMessenger_3(
          this,
          Invocation.getter(#binaryMessenger),
        ),
      ) as _i4.BinaryMessenger);

  @override
  _i6.Future<T?> invokeMethod<T>(
    String? method, [
    dynamic arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #invokeMethod,
          [
            method,
            arguments,
          ],
        ),
        returnValue: _i6.Future<T?>.value(),
      ) as _i6.Future<T?>);

  @override
  _i6.Future<List<T>?> invokeListMethod<T>(
    String? method, [
    dynamic arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #invokeListMethod,
          [
            method,
            arguments,
          ],
        ),
        returnValue: _i6.Future<List<T>?>.value(),
      ) as _i6.Future<List<T>?>);

  @override
  _i6.Future<Map<K, V>?> invokeMapMethod<K, V>(
    String? method, [
    dynamic arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #invokeMapMethod,
          [
            method,
            arguments,
          ],
        ),
        returnValue: _i6.Future<Map<K, V>?>.value(),
      ) as _i6.Future<Map<K, V>?>);

  @override
  void setMethodCallHandler(
          _i6.Future<dynamic> Function(_i3.MethodCall)? handler) =>
      super.noSuchMethod(
        Invocation.method(
          #setMethodCallHandler,
          [handler],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [XFile].
///
/// See the documentation for Mockito's code generation for more information.
class MockXFile extends _i1.Mock implements _i2.XFile {
  MockXFile() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#path),
        ),
      ) as String);

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  _i6.Future<void> saveTo(String? path) => (super.noSuchMethod(
        Invocation.method(
          #saveTo,
          [path],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<int> length() => (super.noSuchMethod(
        Invocation.method(
          #length,
          [],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);

  @override
  _i6.Future<String> readAsString(
          {_i9.Encoding? encoding = const _i9.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsString,
          [],
          {#encoding: encoding},
        ),
        returnValue: _i6.Future<String>.value(_i8.dummyValue<String>(
          this,
          Invocation.method(
            #readAsString,
            [],
            {#encoding: encoding},
          ),
        )),
      ) as _i6.Future<String>);

  @override
  _i6.Future<_i10.Uint8List> readAsBytes() => (super.noSuchMethod(
        Invocation.method(
          #readAsBytes,
          [],
        ),
        returnValue: _i6.Future<_i10.Uint8List>.value(_i10.Uint8List(0)),
      ) as _i6.Future<_i10.Uint8List>);

  @override
  _i6.Stream<_i10.Uint8List> openRead([
    int? start,
    int? end,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #openRead,
          [
            start,
            end,
          ],
        ),
        returnValue: _i6.Stream<_i10.Uint8List>.empty(),
      ) as _i6.Stream<_i10.Uint8List>);

  @override
  _i6.Future<DateTime> lastModified() => (super.noSuchMethod(
        Invocation.method(
          #lastModified,
          [],
        ),
        returnValue: _i6.Future<DateTime>.value(_FakeDateTime_4(
          this,
          Invocation.method(
            #lastModified,
            [],
          ),
        )),
      ) as _i6.Future<DateTime>);
}
