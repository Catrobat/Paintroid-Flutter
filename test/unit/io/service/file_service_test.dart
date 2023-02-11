import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/io/src/service/file_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FileService sut;
  const path = 'test/fixture/image/test.png';
  final testPngFile = await rootBundle.load(path);
  const testDirectory = './test/fixture/image';
  const channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );
  channel
      .setMockMethodCallHandler((MethodCall methodCall) async => testDirectory);

  setUp(() async {
    sut = FileService();
  });

  test('Should provide valid FileService', () async {
    final container = ProviderContainer();
    final imageService = container.read(IFileService.provider);
    expect(imageService, isA<FileService>());
  });

  test('Should return file', () {
    final result = sut.getFile(path);
    final file = result.unwrapOrElse((failure) => fail(failure.message));
    expect(file, isA<File>());
  });

  test('Should save file to Application directory', () async {
    final result = await sut.saveToApplicationDirectory(
      'test1.png',
      testPngFile.buffer.asUint8List(),
    );
    final file = result.unwrapOrElse((failure) => fail(failure.message));
    expect(file, isA<File>());
  });
}
