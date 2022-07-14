import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/io/io.dart';

import 'load_image_test.mocks.dart';

class FakeImage extends Fake implements Image {}

class FakeFailure extends Fake implements Failure {}

@GenerateMocks([IImageService, IFileService])
void main() {
  late FakeImage fakeImage;
  late Uint8List fakeBytes;
  late MockIImageService mockImageService;
  late MockIFileService mockFileService;
  late LoadImage sut;

  setUp(() {
    fakeImage = FakeImage();
    fakeBytes = Uint8List(12);
    mockImageService = MockIImageService();
    mockFileService = MockIFileService();
    sut = LoadImage(mockImageService, mockFileService);
  });

  test('Should provide LoadImage with correct dependencies', () {
    final container = ProviderContainer(overrides: [
      IImageService.provider.overrideWithValue(mockImageService),
      IFileService.provider.overrideWithValue(mockFileService),
    ]);
    final loadImage = container.read(LoadImage.provider);
    expect(loadImage.imageService, mockImageService);
    expect(loadImage.fileService, mockFileService);
    verifyZeroInteractions(mockImageService);
    verifyZeroInteractions(mockFileService);
  });

  test('Should successfully load image from photo library', () async {
    when(mockFileService.loadFromPhotoLibrary())
        .thenReturn(TaskEither.right(fakeBytes));
    when(mockImageService.import(any)).thenReturn(TaskEither.right(fakeImage));
    final result = await sut.prepareTask().run();
    expect(result, Right(fakeImage));
    verify(mockFileService.loadFromPhotoLibrary());
    verify(mockImageService.import(fakeBytes));
    verifyNoMoreInteractions(mockFileService);
    verifyNoMoreInteractions(mockImageService);
  });

  group(
    'Should immediately return failure propagated from the dependencies',
    () {
      late FakeFailure fakeFailure;

      setUp(() {
        fakeFailure = FakeFailure();
      });

      test('On failure from file service', () async {
        when(mockFileService.loadFromPhotoLibrary())
            .thenReturn(TaskEither.left(fakeFailure));
        final result = await sut.prepareTask().run();
        expect(result, Left(fakeFailure));
        verify(mockFileService.loadFromPhotoLibrary());
        verifyNoMoreInteractions(mockFileService);
        verifyZeroInteractions(mockImageService);
      });

      test('On failure from image service', () async {
        when(mockFileService.loadFromPhotoLibrary())
            .thenReturn(TaskEither.right(fakeBytes));
        when(mockImageService.import(any))
            .thenReturn(TaskEither.left(fakeFailure));
        final result = await sut.prepareTask().run();
        expect(result, Left(fakeFailure));
        verify(mockFileService.loadFromPhotoLibrary());
        verify(mockImageService.import(any));
        verifyNoMoreInteractions(mockFileService);
        verifyNoMoreInteractions(mockImageService);
      });
    },
  );
}
