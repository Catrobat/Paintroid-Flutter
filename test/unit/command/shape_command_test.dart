import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/oval_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/star_shape_command.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'shape_command_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  Paint testPaint = Paint();
  late MockCanvas mockCanvas;
  const width = 200.0;
  const height = 200.0;
  const radius = 5.0;
  const angle = 0.0;
  const center = Offset(200, 200);
  const numberOfPoints = 5;

  final squareShapeCommand = SquareShapeCommand(
    testPaint,
    const Offset(0, 0),
    const Offset(200, 0),
    const Offset(0, 200),
    const Offset(200, 200),
    ShapeStyle.outline,
  );

  final ovalShapeCommand = OvalShapeCommand(
    testPaint,
    radius,
    radius,
    center,
    ShapeStyle.outline,
    angle,
  );

  final starShapeCommand = StarShapeCommand(
    testPaint,
    numberOfPoints,
    angle,
    center,
    ShapeStyle.outline,
    radius,
    radius,
  );

  final heartShapeCommand = HeartShapeCommand(
    testPaint,
    width,
    height,
    angle,
    center,
    ShapeStyle.outline,
  );

  setUp(() => mockCanvas = MockCanvas());

  test('SquareShapeCommand: should call drawPath path', () {
    when(mockCanvas.drawPath(any, any)).thenReturn(null);
    squareShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawPath(any, any));
    verifyNoMoreInteractions(mockCanvas);
  });

  test('OvalShapeCommand: should call drawPath path', () {
    when(mockCanvas.drawPath(any, any)).thenReturn(null);
    ovalShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawPath(any, any));
    verifyNoMoreInteractions(mockCanvas);
  });

  test('StarShapeCommand: should call drawPath path', () {
    when(mockCanvas.drawPath(any, any)).thenReturn(null);
    starShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawPath(any, any));
    verifyNoMoreInteractions(mockCanvas);
  });

  test('HeartShapeCommand: should call drawPath path', () {
    when(mockCanvas.drawPath(any, any)).thenReturn(null);
    heartShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawPath(any, any));
    verifyNoMoreInteractions(mockCanvas);
  });
}
