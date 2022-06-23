import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/command/command_factory.dart';
import 'package:paintroid/command/draw_path_command.dart';

void main() {
  late Path testPath;
  late Paint testPaint;
  late CommandFactory sut;

  setUp(() {
    testPath = Path();
    testPaint = Paint();
    sut = CommandFactory();
  });

  test('Should return a valid instance of DrawPathCommand', () {
    final expected = DrawPathCommand(testPath, testPaint);
    final command = sut.createDrawPathCommand(testPath, testPaint);
    expect(command, isA<DrawPathCommand>());
    expect(command, equals(expected));
  });
}
