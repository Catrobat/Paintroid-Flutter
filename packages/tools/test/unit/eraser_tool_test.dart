// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:command/command.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// Project imports:
import 'package:tools/src/eraser_tool/eraser_tool.dart';
import 'package:tools/tools.dart';
import 'eraser_tool_test.mocks.dart';

@GenerateMocks([
  Paint,
  CommandManager,
  CommandFactory,
  GraphicFactory,
])
void main() {
  late MockPaint mockPaint;
  late MockCommandFactory mockCommandFactory;
  late MockCommandManager mockCommandManager;
  late MockGraphicFactory mockGraphicFactory;
  late EraserTool sut;
  setUp(() {
    mockPaint = MockPaint();
    mockCommandFactory = MockCommandFactory();
    mockCommandManager = MockCommandManager();
    mockGraphicFactory = MockGraphicFactory();
    sut = EraserTool(
      paint: mockPaint,
      commandFactory: mockCommandFactory,
      commandManager: mockCommandManager,
      graphicFactory: mockGraphicFactory,
    );
  });

  test('Should return Eraser as ToolType', () {
    expect(sut.type, ToolType.ERASER);
  });
}
