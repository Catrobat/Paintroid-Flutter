import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
//import 'package:paintroid/core/commands/command_implementation/graphic/fill_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/implementation/fill_tool.dart';

void main() {
  late FillTool sut;

  const Offset pointA = Offset(100, 100);

  Paint paint = Paint();

  setUp(() {
    sut = FillTool(
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      graphicFactory: const GraphicFactory(),
      type: ToolType.FILL,
      canvasPainterProvider: CanvasPainterProvider(),
      canvasStateProvider: CanvasStateProvider(),
    );
  });

  test('On down, no command is created', () {
    sut.onDown(pointA, paint);
    expect(sut.commandManager.undoStack.length, 0);
  });

  group('FillTool properties and methods', () {
    test('Should return FILL as ToolType', () {
      expect(sut.type, ToolType.FILL);
    });

    test('updateTolerance should change tolerance', () {
      double initialRadius = sut.tolerancePercent;
      sut.updateTolerance(80.0);
      expect(sut.tolerancePercent, equals(80.0));
      expect(sut.tolerancePercent, isNot(equals(initialRadius)));
    });
  });
}
