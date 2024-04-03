// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';

// Project imports:
import 'package:io_library/io_library.dart';
import 'photo_library_service_test.mocks.dart';

@GenerateMocks([ImagePicker, MethodChannel, XFile])
void main() {
  late String testFilename;
  late Uint8List testImageData;
  late Exception testException;
  late PlatformException testPlatformException;
  late MockImagePicker mockImagePicker;
  late MockMethodChannel mockMethodChannel;
  late PhotoLibraryService sut;

  setUp(() {
    testFilename = 'test_name.xyz';
    testImageData = Uint8List(12);
    testException = Exception('random');
    testPlatformException = PlatformException(code: 'random');
    mockImagePicker = MockImagePicker();
    mockMethodChannel = MockMethodChannel();
    sut = PhotoLibraryService(mockImagePicker, mockMethodChannel);
  });

  test('Should provide FileService with correct MethodChannel name', () async {
    final container = ProviderContainer();
    final photoLibraryService = container.read(IPhotoLibraryService.provider);
    expect(photoLibraryService, isA<PhotoLibraryService>());
    expect(
        (photoLibraryService as PhotoLibraryService).photoLibraryChannel.name,
        'org.catrobat.paintroid/photo_library');
  });

  group('Save file to photo library method', () {
    test(
      'Should successfully return no value when called with correct arguments',
      () async {
        when(mockMethodChannel.invokeMethod(any, any))
            .thenAnswer((_) async => null);
        final expectedArgs = {
          'fileName': testFilename,
          'data': testImageData,
        };
        final result = await sut.save(testFilename, testImageData);
        expect(result, const Ok<Unit, Failure>(unit));
        verify(mockMethodChannel.invokeMethod('saveToPhotos', expectedArgs));
        verifyNoMoreInteractions(mockMethodChannel);
        verifyZeroInteractions(mockImagePicker);
      },
    );

    test(
      'Should return unidentified failure when any unhandled Exception is thrown',
      () async {
        when(mockMethodChannel.invokeMethod(any, any)).thenThrow(testException);
        final result = await sut.save(testFilename, testImageData);
        expect(result, const Err<Unit, Failure>(SaveImageFailure.unidentified));
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
        final result = await sut.save(testFilename, testImageData);
        expect(result, const Err<Unit, Failure>(SaveImageFailure.unidentified));
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
        when(mockImagePicker.pickImage(source: anyNamed('source')))
            .thenAnswer((_) async => mockImageXFile);
        when(mockImageXFile.readAsBytes())
            .thenAnswer((_) async => testImageData);
        final result = await sut.pick();
        expect(result, Ok<Uint8List, Failure>(testImageData));
        verify(mockImagePicker.pickImage(source: ImageSource.gallery));
        verify(mockImageXFile.readAsBytes());
        verifyNoMoreInteractions(mockImageXFile);
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      },
    );

    test(
        'Should return userCancelled failure when user dismisses picker without choosing an image',
        () async {
      when(mockImagePicker.pickImage(source: anyNamed('source')))
          .thenAnswer((_) async => null);
      final result = await sut.pick();
      expect(result,
          const Err<Uint8List, Failure>(LoadImageFailure.userCancelled));
      verify(mockImagePicker.pickImage(source: anyNamed('source')));
      verifyNoMoreInteractions(mockImagePicker);
      verifyZeroInteractions(mockMethodChannel);
    });

    group(
        'Should return unidentified failure when any unhandled Exception is thrown',
        () {
      test('From ImagePicker', () async {
        when(mockImagePicker.pickImage(source: anyNamed('source')))
            .thenThrow(testException);
        final result = await sut.pick();
        expect(result,
            const Err<Uint8List, Failure>(LoadImageFailure.unidentified));
        verify(mockImagePicker.pickImage(source: anyNamed('source')));
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      });

      test('From XFile', () async {
        final mockImageXFile = MockXFile();
        when(mockImagePicker.pickImage(source: anyNamed('source')))
            .thenAnswer((_) async => mockImageXFile);
        when(mockImageXFile.readAsBytes()).thenThrow(testException);
        final result = await sut.pick();
        expect(result,
            const Err<Uint8List, Failure>(LoadImageFailure.unidentified));
        verify(mockImagePicker.pickImage(source: anyNamed('source')));
        verify(mockImageXFile.readAsBytes());
        verifyNoMoreInteractions(mockImageXFile);
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      });
    });

    test(
      'Should return unidentified failure when any unhandled PlatformException is thrown from ImagePicker',
      () async {
        when(mockImagePicker.pickImage(source: anyNamed('source')))
            .thenThrow(testPlatformException);
        final result = await sut.pick();
        expect(result,
            const Err<Uint8List, Failure>(LoadImageFailure.unidentified));
        verify(mockImagePicker.pickImage(source: anyNamed('source')));
        verifyNoMoreInteractions(mockImagePicker);
        verifyZeroInteractions(mockMethodChannel);
      },
    );
  });
}
