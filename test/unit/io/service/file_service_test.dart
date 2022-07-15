import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/io/io.dart';

import 'file_service_test.mocks.dart';

@GenerateMocks([ImagePicker, MethodChannel, XFile])
void main() {
  late String testFilename;
  late Uint8List testImageData;
  late Exception testException;
  late PlatformException testPlatformException;
  late MockImagePicker mockImagePicker;
  late MockMethodChannel mockMethodChannel;
  late FileService sut;

  setUp(() {
    testFilename = "test_name.xyz";
    testImageData = Uint8List(12);
    testException = Exception("random");
    testPlatformException = PlatformException(code: "random");
    mockImagePicker = MockImagePicker();
    mockMethodChannel = MockMethodChannel();
    sut = FileService(mockImagePicker, mockMethodChannel);
  });

  test('Should provide FileService with correct MethodChannel name', () async {
    final container = ProviderContainer();
    final fileService = container.read(IFileService.provider) as FileService;
    expect(fileService.photoLibraryChannel.name,
        "org.catrobat.paintroid/photo_library");
  });

  group('Save file to photo library method', () {
    test(
      'Should successfully return no value when called with correct arguments',
      () async {
        when(mockMethodChannel.invokeMethod(any, any))
            .thenAnswer((_) async => null);
        final expectedArgs = {
          "fileName": testFilename,
          "data": testImageData,
        };
        final result =
            await sut.saveToPhotoLibrary(testFilename, testImageData).run();
        expect(result, const Right(unit));
        verify(mockMethodChannel.invokeMethod("saveToPhotos", expectedArgs));
        verifyNoMoreInteractions(mockMethodChannel);
        verifyZeroInteractions(mockImagePicker);
      },
    );

    test(
        'Should return permissionDenied failure when user denies the permission',
        () async {
      when(mockMethodChannel.invokeMethod(any, any))
          .thenThrow(PlatformException(code: "PERMISSION_DENIED"));
      final result =
          await sut.saveToPhotoLibrary(testFilename, testImageData).run();
      expect(result, const Left(SaveImageFailure.permissionDenied));
      verify(mockMethodChannel.invokeMethod(any, any));
      verifyNoMoreInteractions(mockMethodChannel);
      verifyZeroInteractions(mockImagePicker);
    });

    test(
      'Should return unidentified failure when any unhandled Exception is thrown',
      () async {
        when(mockMethodChannel.invokeMethod(any, any)).thenThrow(testException);
        final result =
            await sut.saveToPhotoLibrary(testFilename, testImageData).run();
        expect(result, const Left(SaveImageFailure.unidentified));
        verify(mockMethodChannel.invokeMethod(any, any));
        verifyNoMoreInteractions(mockMethodChannel);
        verifyZeroInteractions(mockImagePicker);
      },
    );

    test(
      'Should return unidentified failure when any unhandled PlatformException is thrown',
      () async {
        when(mockMethodChannel.invokeMethod(any, any))
            .thenThrow(testPlatformException);
        final result =
            await sut.saveToPhotoLibrary(testFilename, testImageData).run();
        expect(result, const Left(SaveImageFailure.unidentified));
        verify(mockMethodChannel.invokeMethod(any, any));
        verifyNoMoreInteractions(mockMethodChannel);
        verifyZeroInteractions(mockImagePicker);
      },
    );
  });

  group('Load file from photo library method', () {
    test(
      'Should successfully return image in byte list format when user picks an image',
      () async {
        final mockImageXFile = MockXFile();
        when(mockImagePicker.pickImage(source: anyNamed("source")))
            .thenAnswer((_) async => mockImageXFile);
        when(mockImageXFile.readAsBytes())
            .thenAnswer((_) async => testImageData);
        final result = await sut.loadFromPhotoLibrary().run();
        expect(result, Right(testImageData));
        verify(mockImagePicker.pickImage(source: ImageSource.gallery));
        verify(mockImageXFile.readAsBytes());
        verifyNoMoreInteractions(mockImageXFile);
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      },
    );

    test(
        'Should return permissionDenied failure when user denies the permission',
        () async {
      when(mockImagePicker.pickImage(source: anyNamed("source")))
          .thenThrow(PlatformException(code: "photo_access_denied"));
      final result = await sut.loadFromPhotoLibrary().run();
      expect(result, const Left(LoadImageFailure.permissionDenied));
      verify(mockImagePicker.pickImage(source: anyNamed("source")));
      verifyNoMoreInteractions(mockImagePicker);
      verifyZeroInteractions(mockMethodChannel);
    });

    test(
        'Should return userCancelled failure when user dismisses picker without choosing an image',
        () async {
      when(mockImagePicker.pickImage(source: anyNamed("source")))
          .thenAnswer((_) async => null);
      final result = await sut.loadFromPhotoLibrary().run();
      expect(result, const Left(LoadImageFailure.userCancelled));
      verify(mockImagePicker.pickImage(source: anyNamed("source")));
      verifyNoMoreInteractions(mockImagePicker);
      verifyZeroInteractions(mockMethodChannel);
    });

    group(
        'Should return unidentified failure when any unhandled Exception is thrown',
        () {
      test('From ImagePicker', () async {
        when(mockImagePicker.pickImage(source: anyNamed("source"))).thenThrow(testException);
        final result = await sut.loadFromPhotoLibrary().run();
        expect(result, const Left(LoadImageFailure.unidentified));
        verify(mockImagePicker.pickImage(source: anyNamed("source")));
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      });

      test('From XFile', () async {
        final mockImageXFile = MockXFile();
        when(mockImagePicker.pickImage(source: anyNamed("source")))
            .thenAnswer((_) async => mockImageXFile);
        when(mockImageXFile.readAsBytes()).thenThrow(testException);
        final result = await sut.loadFromPhotoLibrary().run();
        expect(result, const Left(LoadImageFailure.unidentified));
        verify(mockImagePicker.pickImage(source: anyNamed("source")));
        verify(mockImageXFile.readAsBytes());
        verifyNoMoreInteractions(mockImageXFile);
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      });
    });

    test(
      'Should return unidentified failure when any unhandled PlatformException is thrown from ImagePicker',
      () async {
        when(mockImagePicker.pickImage(source: anyNamed("source")))
            .thenThrow(testPlatformException);
        final result = await sut.loadFromPhotoLibrary().run();
        expect(result, const Left(LoadImageFailure.unidentified));
        verify(mockImagePicker.pickImage(source: anyNamed("source")));
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      },
    );
  });
}
