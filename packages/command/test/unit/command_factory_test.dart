// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:command/command.dart';

void main() {
  late PathWithActionHistory testPath;
  late Paint testPaint;
  late CommandFactory sut;

  setUp(() {
    testPath = PathWithActionHistory();
    testPaint = Paint();
    sut = const CommandFactory();
  });

  test('Should return a valid instance of DrawPathCommand', () {
    final expected = DrawPathCommand(testPath, testPaint);
    final command = sut.createDrawPathCommand(testPath, testPaint);
    expect(command, isA<DrawPathCommand>());
    expect(command, equals(expected));
  });
}
