import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/core/failure.dart';
import 'package:paintroid/io/io.dart';

import 'load_image_from_photo_library_test.mocks.dart';

class FakeImage extends Fake implements Image {}

class FakeFailure extends Fake implements Failure {}

@GenerateMocks([IImageService, IPermissionService, IPhotoLibraryService])
void main() {
  late FakeImage fakeImage;
  late Uint8List fakeBytes;
  late MockIImageService mockImageService;
  late MockIPermissionService mockPermissionService;
  late MockIPhotoLibraryService mockPhotoLibraryService;
  late LoadImageFromPhotoLibrary sut;

  setUp(() {
    fakeImage = FakeImage();
    fakeBytes = Uint8List(12);
    mockImageService = MockIImageService();
    mockPermissionService = MockIPermissionService();
    mockPhotoLibraryService = MockIPhotoLibraryService();
    sut = LoadImageFromPhotoLibrary(
        mockImageService, mockPermissionService, mockPhotoLibraryService);
  });

  test('Should provide LoadImage with correct dependencies', () {
    final container = ProviderContainer(overrides: [
      IImageService.provider.overrideWithValue(mockImageService),
      IPhotoLibraryService.provider.overrideWithValue(mockPhotoLibraryService),
    ]);
    final loadImage = container.read(LoadImageFromPhotoLibrary.provider);
    expect(loadImage.imageService, mockImageService);
    expect(loadImage.photoLibraryService, mockPhotoLibraryService);
    verifyZeroInteractions(mockImageService);
    verifyZeroInteractions(mockPhotoLibraryService);
  });

  test('Should successfully load image from photo library', () async {
    when(mockPermissionService.requestAccessToPickPhotos())
        .thenAnswer((_) async => true);
    when(mockPhotoLibraryService.pick()).thenAnswer((_) async => Ok(fakeBytes));
    when(mockImageService.import(any)).thenAnswer((_) async => Ok(fakeImage));
    final result = await sut();
    expect(result, Ok<Image, Failure>(fakeImage));
    verify(mockPermissionService.requestAccessToPickPhotos());
    verify(mockPhotoLibraryService.pick());
    verify(mockImageService.import(fakeBytes));
    verifyNoMoreInteractions(mockPermissionService);
    verifyNoMoreInteractions(mockPhotoLibraryService);
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
        when(mockPermissionService.requestAccessToPickPhotos())
            .thenAnswer((_) async => true);
        when(mockPhotoLibraryService.pick())
            .thenAnswer((_) async => Err(fakeFailure));
        final result = await sut();
        expect(result, Err<Image, Failure>(fakeFailure));
        verify(mockPermissionService.requestAccessToPickPhotos());
        verify(mockPhotoLibraryService.pick());
        verifyNoMoreInteractions(mockPermissionService);
        verifyNoMoreInteractions(mockPhotoLibraryService);
        verifyZeroInteractions(mockImageService);
      });

      test('On failure from image service', () async {
        when(mockPermissionService.requestAccessToPickPhotos())
            .thenAnswer((_) async => true);
        when(mockPhotoLibraryService.pick())
            .thenAnswer((_) async => Ok(fakeBytes));
        when(mockImageService.import(any))
            .thenAnswer((_) async => Err(fakeFailure));
        final result = await sut();
        expect(result, Err<Image, Failure>(fakeFailure));
        verify(mockPermissionService.requestAccessToPickPhotos());
        verify(mockPhotoLibraryService.pick());
        verify(mockImageService.import(any));
        verifyNoMoreInteractions(mockPermissionService);
        verifyNoMoreInteractions(mockPhotoLibraryService);
        verifyNoMoreInteractions(mockImageService);
      });
    },
  );
}
