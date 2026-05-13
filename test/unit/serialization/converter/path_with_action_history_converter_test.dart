import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/models/path_model.dart';
import '../utils/dummy_path_factory.dart';

void main() {
  test('Test serialization for PathModel with one path', () {
    PathModel path = DummyPathFactory.createPathModel(1);

    var json = path.toJson();

    PathModel deserializedPath = PathModel.fromJson(json);

    expect(path, equals(deserializedPath));
  });

  test('Test serialization for PathModel with two paths', () {
    PathModel path = DummyPathFactory.createPathModel(2);

    var json = path.toJson();

    PathModel deserializedPath = PathModel.fromJson(json);

    expect(path, equals(deserializedPath));
  });

  test('Test serialization for PathModel with multiple paths', () {
    PathModel path = DummyPathFactory.createPathModel(10);

    var json = path.toJson();

    PathModel deserializedPath = PathModel.fromJson(json);

    expect(path, equals(deserializedPath));
  });
}
