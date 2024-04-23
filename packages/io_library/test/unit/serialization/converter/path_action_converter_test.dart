// Package imports:
import 'package:command/command.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:io_library/io_library.dart';

void main() {
  const PathActionConverter converter = PathActionConverter();

  test('Test converter for MoveToAction', () {
    double xExpected = 1.0;
    double yExpected = 2.0;

    MoveToAction moveToAction = MoveToAction(xExpected, yExpected);

    var json = converter.toJson(moveToAction);

    PathAction deserializedMoveToAction = converter.fromJson(json);

    expect(deserializedMoveToAction, isA<MoveToAction>());
    deserializedMoveToAction as MoveToAction;
    expect(moveToAction, equals(deserializedMoveToAction));
  });

  test('Test converter for LineToAction', () {
    double xExpected = 1.0;
    double yExpected = 2.0;

    LineToAction lineToAction = LineToAction(xExpected, yExpected);

    var json = converter.toJson(lineToAction);

    PathAction deserializedLineToAction = converter.fromJson(json);

    expect(deserializedLineToAction, isA<LineToAction>());
    deserializedLineToAction as LineToAction;
    expect(lineToAction, equals(deserializedLineToAction));
  });

  test('Test converter for CloseAction', () {
    CloseAction closeAction = const CloseAction();

    var json = converter.toJson(closeAction);

    PathAction deserializedCloseAction = converter.fromJson(json);

    expect(deserializedCloseAction, isA<CloseAction>());
  });
}
