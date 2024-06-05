// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';
import 'package:paintroid/core/models/catrobat_image.dart';
import '../utils/dummy_command_factory.dart';
import '../utils/dummy_version_strategy.dart';

void main() {
  group('Version 1', () {
    test('Test CatrobatImage serialization with 1 path', () {
      Iterable<Command> commands =
          DummyCommandFactory.createCommandList(1, version: Version.v1);
      VersionStrategyManager.setStrategy(
          DummyVersionStrategy(catrobatImageVersion: Version.v1));
      CatrobatImage originalImage = CatrobatImage(commands, 100, 200, '');

      Uint8List bytes = originalImage.toBytes();
      CatrobatImage deserializedImage = CatrobatImage.fromBytes(bytes);

      expect(
          DummyCommandFactory.compareCommandLists(
              commands, deserializedImage.commands),
          isTrue);
      expect(originalImage.width, equals(deserializedImage.width));
      expect(originalImage.height, equals(deserializedImage.height));
      expect(originalImage.backgroundImage,
          equals(deserializedImage.backgroundImage));
      expect(Version.v1, equals(deserializedImage.version));
      expect(originalImage.magicValue, equals(deserializedImage.magicValue));
    });

    test('Test CatrobatImage serialization with multiple paths', () {
      Iterable<Command> commands = DummyCommandFactory.createCommandList(5);
      VersionStrategyManager.setStrategy(
          DummyVersionStrategy(catrobatImageVersion: Version.v1));
      CatrobatImage originalImage = CatrobatImage(commands, 100, 200, '');

      Uint8List bytes = originalImage.toBytes();
      CatrobatImage deserializedImage = CatrobatImage.fromBytes(bytes);

      expect(
          DummyCommandFactory.compareCommandLists(
              commands, deserializedImage.commands),
          isTrue);
      expect(originalImage.width, equals(deserializedImage.width));
      expect(originalImage.height, equals(deserializedImage.height));
      expect(originalImage.backgroundImage,
          equals(deserializedImage.backgroundImage));
      expect(Version.v1, equals(deserializedImage.version));
      expect(originalImage.magicValue, equals(deserializedImage.magicValue));
    });
  });
}
