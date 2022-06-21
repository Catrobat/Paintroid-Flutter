import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/command/draw_path.dart';

import 'draw_path_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  late MockCanvas mockCanvas;
  late DrawPath drawPath;

  setUp(() {
    mockCanvas = MockCanvas();
  });

  test(
    'drawPath method is called on the Canvas with given Path and Paint objects',
    () {
      final testPath = Path();
      final testPaint = Paint();
      drawPath = DrawPath(testPath, testPaint);
      when(mockCanvas.drawPath(testPath, testPaint)).thenReturn(null);
      drawPath.call(mockCanvas);
      verify(mockCanvas.drawPath(testPath, testPaint));
      verifyNoMoreInteractions(mockCanvas);
    },
  );
}
