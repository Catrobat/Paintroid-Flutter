import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/models/path_actions/path_action.dart';
import 'package:paintroid/core/models/path_actions/move_to_action.dart';
import 'package:paintroid/core/models/path_actions/line_to_action.dart';
import 'package:paintroid/core/models/path_actions/close_action.dart';

void main() {
  test('Test serialization for MoveToAction', () {
    double xExpected = 1.0;
    double yExpected = 2.0;

    MoveToAction moveToAction = MoveToAction(xExpected, yExpected);

    var json = moveToAction.toJson();

    PathAction deserializedMoveToAction = PathAction.fromJson(json);

    expect(deserializedMoveToAction, isA<MoveToAction>());
    deserializedMoveToAction as MoveToAction;
    expect(moveToAction, equals(deserializedMoveToAction));
  });

  test('Test serialization for LineToAction', () {
    double xExpected = 1.0;
    double yExpected = 2.0;

    LineToAction lineToAction = LineToAction(xExpected, yExpected);

    var json = lineToAction.toJson();

    PathAction deserializedLineToAction = PathAction.fromJson(json);

    expect(deserializedLineToAction, isA<LineToAction>());
    deserializedLineToAction as LineToAction;
    expect(lineToAction, equals(deserializedLineToAction));
  });

  test('Test serialization for CloseAction', () {
    CloseAction closeAction = const CloseAction();

    var json = closeAction.toJson();

    PathAction deserializedCloseAction = PathAction.fromJson(json);

    expect(deserializedCloseAction, isA<CloseAction>());
  });
}
