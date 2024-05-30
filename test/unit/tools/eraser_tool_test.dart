// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/i_command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/eraser_tool.dart';
import 'eraser_tool_test.mocks.dart';

@GenerateMocks([
  Paint,
  ICommandManager,
  CommandFactory,
  GraphicFactory,
])
void main() {
  late MockPaint mockPaint;
  late MockCommandFactory mockCommandFactory;
  late MockICommandManager mockCommandManager;
  late MockGraphicFactory mockGraphicFactory;
  late EraserTool sut;
  setUp(() {
    mockPaint = MockPaint();
    mockCommandFactory = MockCommandFactory();
    mockCommandManager = MockICommandManager();
    mockGraphicFactory = MockGraphicFactory();
    sut = EraserTool(
      paint: mockPaint,
      commandFactory: mockCommandFactory,
      commandManager: mockCommandManager,
      graphicFactory: mockGraphicFactory,
      type: ToolType.ERASER,
    );
  });

  test('Should return Eraser as ToolType', () {
    expect(sut.type, ToolType.ERASER);
  });
}
