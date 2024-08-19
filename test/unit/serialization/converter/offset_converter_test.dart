import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/json_serialization/converter/offset_converter.dart';

void main() {
  OffsetConverter converter = const OffsetConverter();

  test('Basic Offset', () {
    Offset offset = const Offset(0.0, 0.0);
    var json = converter.toJson(offset);

    Offset deserializedOffset = converter.fromJson(json);
    expect(offset, equals(deserializedOffset));
  });

  test('Positive Offset', () {
    Offset offset = const Offset(2.0, 2.0);
    var json = converter.toJson(offset);

    Offset deserializedOffset = converter.fromJson(json);
    expect(offset, equals(deserializedOffset));
  });

  test('Negative Offset', () {
    Offset offset = const Offset(-1.0, -2.0);
    var json = converter.toJson(offset);

    Offset deserializedOffset = converter.fromJson(json);
    expect(offset, equals(deserializedOffset));
  });
}
