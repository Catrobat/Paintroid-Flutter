import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/io/io.dart';

import 'save_image_test.mocks.dart';

class FakeImage extends Fake implements Image {}

@GenerateMocks([IImageService, IFileService])
void main() {
  late MockIImageService mockImageService;
  late MockIFileService mockFileService;
  late SaveImage sut;

  setUp(() {
    mockImageService = MockIImageService();
    mockFileService = MockIFileService();
    sut =
        SaveImage(imageService: mockImageService, fileService: mockFileService);
  });

  group(
    'Should convert image to bytes and save to the photo library with correct name',
    () {
      const testName = "testImageName";
      const testQuality = 83;
      final fakeImage = FakeImage();
      final fakeBytes = Uint8List(12);
      late ImageMetaData testMetaData;

      test('For png format', () async {
        const expectedFilename = "$testName.png";
        when(mockImageService.exportAsPng(fakeImage))
            .thenReturn(TaskOption.of(fakeBytes));
        when(mockFileService.saveToPhotoLibrary(expectedFilename, fakeBytes))
            .thenReturn(TaskOption.of(unit));
        testMetaData =
            const ImageMetaData(testName, ImageFormat.png, testQuality);
        await sut.prepareTask(metaData: testMetaData, image: fakeImage).run();
        verify(mockImageService.exportAsPng(fakeImage));
        verify(mockFileService.saveToPhotoLibrary(expectedFilename, fakeBytes));
        verifyNoMoreInteractions(mockImageService);
        verifyNoMoreInteractions(mockFileService);
      });

      test('For jpg format', () async {
        const expectedFilename = "$testName.jpg";
        when(mockImageService.exportAsJpg(fakeImage, testQuality))
            .thenReturn(TaskOption.of(fakeBytes));
        when(mockFileService.saveToPhotoLibrary(expectedFilename, fakeBytes))
            .thenReturn(TaskOption.of(unit));
        testMetaData =
            const ImageMetaData(testName, ImageFormat.jpg, testQuality);
        await sut.prepareTask(metaData: testMetaData, image: fakeImage).run();
        verify(mockImageService.exportAsJpg(fakeImage, testQuality));
        verify(mockFileService.saveToPhotoLibrary(expectedFilename, fakeBytes));
        verifyNoMoreInteractions(mockImageService);
        verifyNoMoreInteractions(mockFileService);
      });
    },
  );
}
