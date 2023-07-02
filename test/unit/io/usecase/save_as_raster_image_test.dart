import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/io/io.dart';

import 'save_as_raster_image_test.mocks.dart';

class FakeImage extends Fake implements Image {}

class FakeFailure extends Fake implements Failure {}

@GenerateMocks([
  IImageService,
  IPhotoLibraryService,
  IFileService,
  IPermissionService,
])
void main() {
  late String testName;
  late int testQuality;
  late FakeImage fakeImage;
  late Uint8List fakeBytes;
  late MockIImageService mockImageService;
  late MockIPermissionService mockPermissionService;
  late MockIPhotoLibraryService mockPhotoLibraryService;
  late SaveAsRasterImage sut;

  setUp(() {
    testName = "testImageName";
    testQuality = 83;
    fakeImage = FakeImage();
    fakeBytes = Uint8List(12);
    mockImageService = MockIImageService();
    mockPermissionService = MockIPermissionService();
    mockPhotoLibraryService = MockIPhotoLibraryService();
    sut = SaveAsRasterImage(
        mockImageService, mockPermissionService, mockPhotoLibraryService);
  });

  test('Should provide SaveImage with correct dependencies', () {
    final container = ProviderContainer(overrides: [
      IImageService.provider.overrideWithValue(mockImageService),
      IPhotoLibraryService.provider.overrideWithValue(mockPhotoLibraryService),
    ]);
    final saveImage = container.read(SaveAsRasterImage.provider);
    expect(saveImage.imageService, mockImageService);
    expect(saveImage.photoLibraryService, mockPhotoLibraryService);
    verifyZeroInteractions(mockImageService);
    verifyZeroInteractions(mockPhotoLibraryService);
  });

  group(
    'Should successfully save image to the photo library with the correct filename',
    () {
      test('When format is png', () async {
        final expectedFilename = "$testName.png";
        when(mockPermissionService.requestAccessForSavingToPhotos())
            .thenAnswer((_) async => true);
        when(mockImageService.exportAsPng(any))
            .thenAnswer((_) async => Ok(fakeBytes));
        when(mockPhotoLibraryService.save(any, any))
            .thenAnswer((_) async => Ok(unit));
        final testMetaData = PngMetaData(testName);
        final result = await sut(testMetaData, fakeImage);
        expect(result, Ok<Unit, Failure>(unit));
        verify(mockPermissionService.requestAccessForSavingToPhotos());
        verify(mockImageService.exportAsPng(fakeImage));
        verify(mockPhotoLibraryService.save(expectedFilename, fakeBytes));
        verifyNoMoreInteractions(mockPermissionService);
        verifyNoMoreInteractions(mockImageService);
        verifyNoMoreInteractions(mockPhotoLibraryService);
      });

      test('When format is jpg', () async {
        final expectedFilename = "$testName.jpg";
        when(mockPermissionService.requestAccessForSavingToPhotos())
            .thenAnswer((_) async => true);
        when(mockImageService.exportAsJpg(any, any))
            .thenAnswer((_) async => Ok(fakeBytes));
        when(mockPhotoLibraryService.save(any, any))
            .thenAnswer((_) async => Ok(unit));
        final testMetaData = JpgMetaData(testName, testQuality);
        final result = await sut(testMetaData, fakeImage);
        expect(result, Ok<Unit, Failure>(unit));
        verify(mockPermissionService.requestAccessForSavingToPhotos());
        verify(mockImageService.exportAsJpg(fakeImage, testQuality));
        verify(mockPhotoLibraryService.save(expectedFilename, fakeBytes));
        verifyNoMoreInteractions(mockPermissionService);
        verifyNoMoreInteractions(mockImageService);
        verifyNoMoreInteractions(mockPhotoLibraryService);
      });
    },
  );

  group(
    'Should immediately return failure propagated from the dependencies',
    () {
      late FakeFailure fakeFailure;

      setUp(() {
        fakeFailure = FakeFailure();
      });

      group('On failure from photo library service', () {
        test('When format is jpg', () async {
          when(mockPermissionService.requestAccessForSavingToPhotos())
              .thenAnswer((_) async => true);
          when(mockImageService.exportAsJpg(any, any))
              .thenAnswer((_) async => Ok(fakeBytes));
          when(mockPhotoLibraryService.save(any, any))
              .thenAnswer((_) async => Err(fakeFailure));
          final testMetaData = JpgMetaData(testName, testQuality);
          final result = await sut(testMetaData, fakeImage);
          expect(result, Err<Unit, Failure>(fakeFailure));
          verify(mockPermissionService.requestAccessForSavingToPhotos());
          verify(mockImageService.exportAsJpg(any, any));
          verify(mockPhotoLibraryService.save(any, any));
          verifyNoMoreInteractions(mockPermissionService);
          verifyNoMoreInteractions(mockImageService);
          verifyNoMoreInteractions(mockPhotoLibraryService);
        });

        test('When format is png', () async {
          when(mockPermissionService.requestAccessForSavingToPhotos())
              .thenAnswer((_) async => true);
          when(mockImageService.exportAsPng(any))
              .thenAnswer((_) async => Ok(fakeBytes));
          when(mockPhotoLibraryService.save(any, any))
              .thenAnswer((_) async => Err(fakeFailure));
          final testMetaData = PngMetaData(testName);
          final result = await sut(testMetaData, fakeImage);
          expect(result, Err<Unit, Failure>(fakeFailure));
          verify(mockPermissionService.requestAccessForSavingToPhotos());
          verify(mockImageService.exportAsPng(any));
          verify(mockPhotoLibraryService.save(any, any));
          verifyNoMoreInteractions(mockPermissionService);
          verifyNoMoreInteractions(mockImageService);
          verifyNoMoreInteractions(mockPhotoLibraryService);
        });
      });

      group('On failure from image service', () {
        test('When format is jpg', () async {
          when(mockPermissionService.requestAccessForSavingToPhotos())
              .thenAnswer((_) async => true);
          when(mockImageService.exportAsJpg(any, any))
              .thenAnswer((_) async => Err(fakeFailure));
          final testMetaData = JpgMetaData(testName, testQuality);
          final result = await sut(testMetaData, fakeImage);
          expect(result, Err<Unit, Failure>(fakeFailure));
          verify(mockPermissionService.requestAccessForSavingToPhotos());
          verify(mockImageService.exportAsJpg(any, any));
          verifyNoMoreInteractions(mockPermissionService);
          verifyNoMoreInteractions(mockImageService);
          verifyZeroInteractions(mockPhotoLibraryService);
        });

        test('When format is png', () async {
          when(mockPermissionService.requestAccessForSavingToPhotos())
              .thenAnswer((_) async => true);
          when(mockImageService.exportAsPng(any))
              .thenAnswer((_) async => Err(fakeFailure));
          final testMetaData = PngMetaData(testName);
          final result = await sut(testMetaData, fakeImage);
          expect(result, Err<Unit, Failure>(fakeFailure));
          verify(mockPermissionService.requestAccessForSavingToPhotos());
          verify(mockImageService.exportAsPng(any));
          verifyNoMoreInteractions(mockPermissionService);
          verifyNoMoreInteractions(mockImageService);
          verifyZeroInteractions(mockPhotoLibraryService);
        });
      });

      group('When permission is denied', () {
        test('and format is jpg', () async {
          when(mockPermissionService.requestAccessForSavingToPhotos())
              .thenAnswer((_) async => false);
          final testMetaData = JpgMetaData(testName, testQuality);
          final result = await sut(testMetaData, fakeImage);
          expect(result, Err<Unit, Failure>(SaveImageFailure.permissionDenied));
          verify(mockPermissionService.requestAccessForSavingToPhotos());
          verifyNoMoreInteractions(mockPermissionService);
          verifyZeroInteractions(mockImageService);
          verifyZeroInteractions(mockPhotoLibraryService);
        });

        test('and format is png', () async {
          when(mockPermissionService.requestAccessForSavingToPhotos())
              .thenAnswer((_) async => false);
          final testMetaData = PngMetaData(testName);
          final result = await sut(testMetaData, fakeImage);
          expect(result, Err<Unit, Failure>(SaveImageFailure.permissionDenied));
          verify(mockPermissionService.requestAccessForSavingToPhotos());
          verifyNoMoreInteractions(mockPermissionService);
          verifyZeroInteractions(mockImageService);
          verifyZeroInteractions(mockPhotoLibraryService);
        });
      });
    },
  );
}
