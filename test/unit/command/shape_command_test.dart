import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
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
  final circleAsEllipseShapeCommand = EllipseShapeCommand(
    testPaint,
    radius,
    radius,
    center,
  );

  const ellipseRadiusX = 10.0;
  const ellipseRadiusY = 15.0;
  const ellipseCenter = Offset(300, 300);
  const ellipseAngle = 0.5;
  final ellipseShapeCommand = EllipseShapeCommand(
    testPaint,
    ellipseRadiusX,
    ellipseRadiusY,
    ellipseCenter,
    angle: ellipseAngle,
  );

  setUp(() => mockCanvas = MockCanvas());

  test('SquareShapeCommand: should call drawPath', () {
    squareShapeCommand.call(mockCanvas);
    verify(mockCanvas.drawPath(any, testPaint)).called(1);
    verifyNoMoreInteractions(mockCanvas);
  });

  test('EllipseShapeCommand (as Circle): should call drawOval', () {
    circleAsEllipseShapeCommand.call(mockCanvas);
    verify(mockCanvas.save()).called(1);
    verify(mockCanvas.translate(center.dx, center.dy)).called(1);
    verify(mockCanvas.rotate(0.0)).called(1);
    verify(mockCanvas.drawOval(any, testPaint)).called(1);
    verify(mockCanvas.restore()).called(1);
    verifyNoMoreInteractions(mockCanvas);
  });

  test('EllipseShapeCommand: should call drawOval for an ellipse', () {
    ellipseShapeCommand.call(mockCanvas);
    verify(mockCanvas.save()).called(1);
    verify(mockCanvas.translate(ellipseCenter.dx, ellipseCenter.dy)).called(1);
    verify(mockCanvas.rotate(ellipseAngle)).called(1);
    verify(mockCanvas.drawOval(any, testPaint)).called(1);
    verify(mockCanvas.restore()).called(1);
    verifyNoMoreInteractions(mockCanvas);
  });
}
