import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/command/command_manager.dart';
import 'package:paintroid/command/draw_command.dart';
import 'package:paintroid/command/draw_path.dart';
import 'package:paintroid/tool/brush_tool.dart';

import 'brush_tool_test.mocks.dart';

@GenerateMocks([Paint, CommandManager<DrawCommand>])
void main() => _Tests().runAll();

class _Tests {
  late MockPaint mockPaint;
  late MockCommandManager<DrawCommand> mockCommandManager;
  late BrushTool brushTool;

  List<DrawCommand> get _emptyListOfDrawCommands => List.from(<DrawCommand>[]);

  List<DrawCommand> get _listWithOneDrawPathCommand =>
      List.from(<DrawCommand>[DrawPath(Path(), Paint())]);

  void runAll() {
    setUp(() {
      mockPaint = MockPaint();
      mockCommandManager = MockCommandManager();
    });

    group(
      'Tests that require a DrawPath Command as the last command in CommandManager',
      () {
        setUp(() {
          when(mockCommandManager.commands)
              .thenReturn(_listWithOneDrawPathCommand);
          brushTool = BrushTool(
            paint: mockPaint,
            commandManager: mockCommandManager,
          );
        });
        _runTestsWithDrawPathRequirement();
      },
    );

    group(
      'Tests that do not require any previously stored Commands in CommandManager',
      () {
        setUp(() {
          when(mockCommandManager.commands)
              .thenReturn(_emptyListOfDrawCommands);
          brushTool = BrushTool(
            paint: mockPaint,
            commandManager: mockCommandManager,
          );
        });
        _runTestsWithoutDrawPathRequirement();
      },
    );
  }

  void _runTestsWithDrawPathRequirement() {
    test(
      'Should NOT add another DrawPath Command to CommandManager on "drag" event',
      () {
        brushTool.onDrag(Offset.zero);
        expect(mockCommandManager.commands.length, equals(1));
      },
    );

    group(
      'Should NOT add another DrawPath Command to CommandManager on "tap up" event',
      () {
        test('With tap location coordination provided', () {
          brushTool.onUp(null);
          expect(mockCommandManager.commands.length, equals(1));
        });

        test('With tap location coordination NOT provided', () {
          // brushTool.onDown(Offset.zero);
          brushTool.onUp(Offset.zero);
          expect(mockCommandManager.commands.length, equals(1));
        });
      },
    );
  }

  void _runTestsWithoutDrawPathRequirement() {
    test(
      'Should add one DrawPath Command to CommandManager on "tap down" event',
      () {
        when(mockCommandManager.commands).thenReturn(_emptyListOfDrawCommands);
        brushTool = BrushTool(
          paint: mockPaint,
          commandManager: mockCommandManager,
        );
        brushTool.onDown(Offset.zero);
        expect(mockCommandManager.commands.length, equals(1));
        expect(mockCommandManager.commands.first, isA<DrawPath>());
      },
    );
  }
}
