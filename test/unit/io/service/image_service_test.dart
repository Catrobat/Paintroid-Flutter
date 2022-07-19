import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/io/io.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final testPngFile = await rootBundle.load("test/fixture/image/test.png");
  final testJpgFile = await rootBundle.load("test/fixture/image/test.jpg");
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
      final result = await sut.import(testJpgFile.buffer.asUint8List()).run();
      final img = result.getOrElse((failure) => fail(failure.message));
      expect(img.width, equals(50));
      expect(img.height, equals(50));
    });

    test('Should return jpg image with valid dimensions', () async {
      final result = await sut.import(testPngFile.buffer.asUint8List()).run();
      final img = result.getOrElse((failure) => fail(failure.message));
      expect(img.width, equals(50));
      expect(img.height, equals(50));
    });
  });
}
