import 'dart:ui';

import 'package:command/command.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'draw_path_command_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  late MockCanvas mockCanvas;
  late DrawPathCommand drawPath;

  setUp(() {
    mockCanvas = MockCanvas();
  });

  test(
    'drawPath method is called on the Canvas with given Path and Paint objects',
    () {
      final testPath = PathWithActionHistory();
      final testPaint = Paint();
      drawPath = DrawPathCommand(testPath, testPaint);
      when(mockCanvas.drawPath(testPath, testPaint)).thenReturn(null);
      drawPath.call(mockCanvas);
      verify(mockCanvas.drawPath(testPath, testPaint));
      verifyNoMoreInteractions(mockCanvas);
    },
  );
}
