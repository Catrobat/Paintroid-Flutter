import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/io/io.dart';

import 'save_image_test.mocks.dart';

class FakeImage extends Fake implements Image {}

class FakeFailure extends Fake implements Failure {}

@GenerateMocks([IImageService, IFileService])
void main() {
  late String testName;
  late int testQuality;
  late FakeImage fakeImage;
  late Uint8List fakeBytes;
  late MockIImageService mockImageService;
  late MockIFileService mockFileService;
  late SaveImage sut;

  setUp(() {
    testName = "testImageName";
    testQuality = 83;
    fakeImage = FakeImage();
    fakeBytes = Uint8List(12);
    mockImageService = MockIImageService();
    mockFileService = MockIFileService();
    sut = SaveImage(mockImageService, mockFileService);
  });

  test('Should provide SaveImage with correct dependencies', () {
    final container = ProviderContainer(overrides: [
      IImageService.provider.overrideWithValue(mockImageService),
      IFileService.provider.overrideWithValue(mockFileService),
    ]);
    final saveImage = container.read(SaveImage.provider);
    expect(saveImage.imageService, mockImageService);
    expect(saveImage.fileService, mockFileService);
    verifyZeroInteractions(mockImageService);
    verifyZeroInteractions(mockFileService);
  });

  group(
    'Should successfully save image to the photo library with the correct filename',
    () {
      test('When format is png', () async {
        final expectedFilename = "$testName.png";
        when(mockImageService.exportAsPng(any))
            .thenReturn(TaskEither.right(fakeBytes));
        when(mockFileService.saveToPhotoLibrary(any, any))
            .thenReturn(TaskEither.right(unit));
        final testMetaData =
            ImageMetaData(testName, ImageFormat.png, testQuality);
        final result = await sut
            .prepareTask(metaData: testMetaData, image: fakeImage)
            .run();
        expect(result, const Right(unit));
        verify(mockImageService.exportAsPng(fakeImage));
        verify(mockFileService.saveToPhotoLibrary(expectedFilename, fakeBytes));
        verifyNoMoreInteractions(mockImageService);
        verifyNoMoreInteractions(mockFileService);
      });

      test('When format is jpg', () async {
        final expectedFilename = "$testName.jpg";
        when(mockImageService.exportAsJpg(any, any))
            .thenReturn(TaskEither.right(fakeBytes));
        when(mockFileService.saveToPhotoLibrary(any, any))
            .thenReturn(TaskEither.right(unit));
        final testMetaData =
            ImageMetaData(testName, ImageFormat.jpg, testQuality);
        final result = await sut
            .prepareTask(metaData: testMetaData, image: fakeImage)
            .run();
        expect(result, const Right(unit));
        verify(mockImageService.exportAsJpg(fakeImage, testQuality));
        verify(mockFileService.saveToPhotoLibrary(expectedFilename, fakeBytes));
        verifyNoMoreInteractions(mockImageService);
        verifyNoMoreInteractions(mockFileService);
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

      group('On failure from file service', () {
        test('When format is jpg', () async {
          when(mockImageService.exportAsJpg(any, any))
              .thenReturn(TaskEither.right(fakeBytes));
          when(mockFileService.saveToPhotoLibrary(any, any))
              .thenReturn(TaskEither.left(fakeFailure));
          final testMetaData =
              ImageMetaData(testName, ImageFormat.jpg, testQuality);
          final result = await sut
              .prepareTask(metaData: testMetaData, image: fakeImage)
              .run();
          expect(result, Left(fakeFailure));
          verify(mockImageService.exportAsJpg(any, any));
          verify(mockFileService.saveToPhotoLibrary(any, any));
          verifyNoMoreInteractions(mockImageService);
          verifyNoMoreInteractions(mockFileService);
        });

        test('When format is png', () async {
          when(mockImageService.exportAsPng(any))
              .thenReturn(TaskEither.right(fakeBytes));
          when(mockFileService.saveToPhotoLibrary(any, any))
              .thenReturn(TaskEither.left(fakeFailure));
          final testMetaData =
              ImageMetaData(testName, ImageFormat.png, testQuality);
          final result = await sut
              .prepareTask(metaData: testMetaData, image: fakeImage)
              .run();
          expect(result, Left(fakeFailure));
          verify(mockImageService.exportAsPng(any));
          verify(mockFileService.saveToPhotoLibrary(any, any));
          verifyNoMoreInteractions(mockImageService);
          verifyNoMoreInteractions(mockFileService);
        });
      });

      group('On failure from image service', () {
        test('When format is jpg', () async {
          when(mockImageService.exportAsJpg(any, any))
              .thenReturn(TaskEither.left(fakeFailure));
          final testMetaData =
              ImageMetaData(testName, ImageFormat.jpg, testQuality);
          final result = await sut
              .prepareTask(metaData: testMetaData, image: fakeImage)
              .run();
          expect(result, Left(fakeFailure));
          verify(mockImageService.exportAsJpg(any, any));
          verifyNoMoreInteractions(mockImageService);
          verifyZeroInteractions(mockFileService);
        });

        test('When format is png', () async {
          when(mockImageService.exportAsPng(any))
              .thenReturn(TaskEither.left(fakeFailure));
          final testMetaData =
              ImageMetaData(testName, ImageFormat.png, testQuality);
          final result = await sut
              .prepareTask(metaData: testMetaData, image: fakeImage)
              .run();
          expect(result, Left(fakeFailure));
          verify(mockImageService.exportAsPng(any));
          verifyNoMoreInteractions(mockImageService);
          verifyZeroInteractions(mockFileService);
        });
      });
    },
  );
}
