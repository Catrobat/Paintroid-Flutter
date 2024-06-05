// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/json_serialization/converter/path_with_action_history_converter.dart';
import '../utils/dummy_path_factory.dart';

void main() {
  const PathWithActionHistoryConverter converter =
      PathWithActionHistoryConverter();

  test('Test converter for PathWithActionHistory with one path', () {
    PathWithActionHistory path =
        DummyPathFactory.createPathWithActionHistory(1);

    var json = converter.toJson(path);

    PathWithActionHistory deserializedPath = converter.fromJson(json);

    expect(path, equals(deserializedPath));
  });

  test('Test converter for PathWithActionHistory with two paths', () {
    PathWithActionHistory path =
        DummyPathFactory.createPathWithActionHistory(2);

    var json = converter.toJson(path);

    PathWithActionHistory deserializedPath = converter.fromJson(json);

    expect(path, equals(deserializedPath));
  });

  test('Test converter for PathWithActionHistory with multiple paths', () {
    PathWithActionHistory path =
        DummyPathFactory.createPathWithActionHistory(10);

    var json = converter.toJson(path);

    PathWithActionHistory deserializedPath = converter.fromJson(json);

    expect(path, equals(deserializedPath));
  });
}
