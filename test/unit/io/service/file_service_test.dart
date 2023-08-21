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
  final defaultBinaryMessenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  defaultBinaryMessenger.setMockMethodCallHandler(
      channel, (MethodCall methodCall) async => testDirectory);

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

  test('Should save file to Application directory and delete it', () async {
    final result = await sut.saveToApplicationDirectory(
      'test1.png',
      testPngFile.buffer.asUint8List(),
    );
    final file = result.unwrapOrElse((failure) => fail(failure.message));
    expect(file, isA<File>());

    final resultDeleted =
        await sut.deleteFileInApplicationDirectory('test1.png');
    final deleted =
        resultDeleted.unwrapOrElse((failure) => fail(failure.message));
    expect(deleted, isA<FileSystemEntity>());
  });

  test('Should save file to Application directory and check should return true',
      () async {
    final fileDoesNotExist =
        await sut.checkIfFileExistsInApplicationDirectory('test1.png');

    expect(fileDoesNotExist, false);

    final result = await sut.saveToApplicationDirectory(
      'test1.png',
      testPngFile.buffer.asUint8List(),
    );
    final file = result.unwrapOrElse((failure) => fail(failure.message));
    expect(file, isA<File>());

    final fileExists =
        await sut.checkIfFileExistsInApplicationDirectory('test1.png');

    expect(fileExists, true);
  });
}
