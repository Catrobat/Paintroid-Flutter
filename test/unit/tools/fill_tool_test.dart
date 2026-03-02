import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/fill_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/fill_tool.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CommandManager commandManager;
  late FillTool sut;
  late ui.Paint paint;

  Future<ui.Image> imageFromRgba(Uint8List rgba, int width, int height) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgba,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    return completer.future;
  }

  setUp(() {
    commandManager = CommandManager();
    paint = ui.Paint()..color = const ui.Color(0xFF000000);
  });

  test('Does not add command when source image is null', () async {
    sut = FillTool(
      commandFactory: const CommandFactory(),
      commandManager: commandManager,
      graphicFactory: const GraphicFactory(),
      type: ToolType.FILL,
      getSourceImage: () async => null,
      onFillApplied: () async {},
    );

    sut.onDown(const ui.Offset(0, 0), paint);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(commandManager.undoStack, isEmpty);
  });

  test('Adds FillCommand when fill is applied', () async {
    final source = await imageFromRgba(
      Uint8List.fromList([
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
        255,
      ]),
      2,
      2,
    );

    final appliedCompleter = Completer<void>();

    sut = FillTool(
      commandFactory: const CommandFactory(),
      commandManager: commandManager,
      graphicFactory: const GraphicFactory(),
      type: ToolType.FILL,
      getSourceImage: () async => source,
      onFillApplied: () async {
        if (!appliedCompleter.isCompleted) {
          appliedCompleter.complete();
        }
      },
    );

    sut.onDown(const ui.Offset(0, 0), paint);
    await appliedCompleter.future;

    expect(commandManager.undoStack.length, 1);
    expect(commandManager.undoStack.first, isA<FillCommand>());
  });
}
