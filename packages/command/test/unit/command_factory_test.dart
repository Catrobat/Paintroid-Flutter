import 'dart:ui';

import 'package:command/command.dart';
import 'package:flutter_test/flutter_test.dart';

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
    final expected = PathCommand(testPath, testPaint);
    final command = sut.createPathCommand(testPath, testPaint);
    expect(command, isA<PathCommand>());
    expect(command, equals(expected));
  });
}
