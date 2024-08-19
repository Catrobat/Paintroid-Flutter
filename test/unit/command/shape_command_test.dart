import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/circle_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'shape_command_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  Paint testPaint = Paint();
  late MockCanvas mockCanvas;

  final squareShapeCommand = SquareShapeCommand(
    testPaint,
    const Offset(0, 0),
    const Offset(200, 0),
    const Offset(0, 200),
    const Offset(200, 200),
  );

  const radius = 5.0;
  const center = Offset(200, 200);
  final circleShapeCommand = CircleShapeCommand(testPaint, radius, center);

  setUp(() => mockCanvas = MockCanvas());

  test('SquareShapeCommand: should call drawPath path', () {
    when(mockCanvas.drawPath(any, testPaint)).thenReturn(null);
    squareShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawPath(any, testPaint));
    verifyNoMoreInteractions(mockCanvas);
  });

  test('CircleShapeCommand: should call drawCircle with radius, center', () {
    when(mockCanvas.drawCircle(any, any, testPaint)).thenReturn(null);
    circleShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawCircle(any, any, testPaint));
    verifyNoMoreInteractions(mockCanvas);
  });
}
