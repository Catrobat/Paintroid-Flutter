import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/models/path_model.dart';
import 'draw_path_command_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  late MockCanvas mockCanvas;
  late PathCommand drawPath;

  setUp(() {
    mockCanvas = MockCanvas();
  });

  test(
    'drawPath method is called on the Canvas with given Path and Paint objects',
    () {
      final testPath = PathModel();
      final testPaint = Paint();
      drawPath = PathCommand(testPath, testPaint);
      when(mockCanvas.drawPath(testPath.nativePath, testPaint)).thenReturn(null);
      drawPath.call(mockCanvas);
      verify(mockCanvas.drawPath(testPath.nativePath, testPaint));
      verifyNoMoreInteractions(mockCanvas);
    },
  );
}
