import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/text_command.dart';

import 'text_command_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  late MockCanvas mockCanvas;
  const Offset point = Offset(100, 100);
  const String text = 'Hello';
  const double fontSize = 20;
  const double rotationAngle = 0.0;
  final TextStyle style = const TextStyle(fontSize: fontSize, color: Colors.black);
  final Paint paint = Paint();

  setUp(() {
    mockCanvas = MockCanvas();
  });

  test('TextCommand: should call canvas methods to draw text', () {
    final command = TextCommand(
      point,
      text,
      style,
      fontSize,
      paint,
      rotationAngle: rotationAngle,
    );

    command.call(mockCanvas);

    verify(mockCanvas.save()).called(1);
    verify(mockCanvas.translate(point.dx, point.dy)).called(1);
    verify(mockCanvas.rotate(rotationAngle)).called(1);
    verify(mockCanvas.restore()).called(1);
  });
}
