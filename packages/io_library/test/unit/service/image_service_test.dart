// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:io_library/io_library.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final testPngFile = await rootBundle.load('test/fixture/image/test.png');
  final testJpgFile = await rootBundle.load('test/fixture/image/test.jpg');
  late ImageService sut;

  setUp(() async {
    sut = ImageService();
  });

  test('Should provide valid ImageService', () async {
    final container = ProviderContainer();
    final imageService = container.read(IImageService.provider);
    expect(imageService, isA<ImageService>());
  });

  group('import method', () {
    test('Should return jpg image with valid dimensions', () async {
      final result = await sut.import(testJpgFile.buffer.asUint8List());
      final img = result.unwrapOrElse((failure) => fail(failure.message));
      expect(img.width, equals(50));
      expect(img.height, equals(50));
    });

    test('Should return jpg image with valid dimensions', () async {
      final result = await sut.import(testPngFile.buffer.asUint8List());
      final img = result.unwrapOrElse((failure) => fail(failure.message));
      expect(img.width, equals(50));
      expect(img.height, equals(50));
    });
  });

  test('Should return project preview', () {
    const path = 'test/fixture/image/test.png';
    final result = sut.getProjectPreview(path);
    final imgPreview = result.unwrapOrElse((failure) => fail(failure.message));
    expect(imgPreview, isA<Uint8List>());
  });
}
