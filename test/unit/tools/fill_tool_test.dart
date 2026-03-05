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

  Future<ui.Image> imageFromPng(Uint8List pngBytes) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(pngBytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  int rgbaIndex(int x, int y, int width) => (y * width + x) * 4;

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

  test('Filling outer region does not fill inner enclosed region', () async {
    const width = 9;
    const height = 9;
    final rgba = Uint8List(width * height * 4);

    void setPixel(int x, int y, int r, int g, int b, int a) {
      final index = rgbaIndex(x, y, width);
      rgba[index] = r;
      rgba[index + 1] = g;
      rgba[index + 2] = b;
      rgba[index + 3] = a;
    }

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        setPixel(x, y, 255, 255, 255, 255);
      }
    }

    for (int x = 1; x <= 7; x++) {
      setPixel(x, 1, 0, 0, 0, 255);
      setPixel(x, 7, 0, 0, 0, 255);
    }
    for (int y = 1; y <= 7; y++) {
      setPixel(1, y, 0, 0, 0, 255);
      setPixel(7, y, 0, 0, 0, 255);
    }

    for (int x = 3; x <= 5; x++) {
      setPixel(x, 3, 0, 0, 0, 255);
      setPixel(x, 5, 0, 0, 0, 255);
    }
    for (int y = 3; y <= 5; y++) {
      setPixel(3, y, 0, 0, 0, 255);
      setPixel(5, y, 0, 0, 0, 255);
    }

    final source = await imageFromRgba(rgba, width, height);
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

    sut.onDown(const ui.Offset(2, 2), paint);
    await appliedCompleter.future;

    expect(commandManager.undoStack.length, 1);
    final fillCommand = commandManager.undoStack.first as FillCommand;
    final outputImage = await imageFromPng(fillCommand.imageData);
    final outputData =
        await outputImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    expect(outputData, isNotNull);

    final outputPixels = outputData!.buffer.asUint8List();

    final innerIndex = rgbaIndex(4, 4, width);
    expect(outputPixels[innerIndex], 255);
    expect(outputPixels[innerIndex + 1], 255);
    expect(outputPixels[innerIndex + 2], 255);
    expect(outputPixels[innerIndex + 3], 255);

    final annulusIndex = rgbaIndex(2, 2, width);
    expect(outputPixels[annulusIndex], 0);
    expect(outputPixels[annulusIndex + 1], 0);
    expect(outputPixels[annulusIndex + 2], 0);
    expect(outputPixels[annulusIndex + 3], 255);
  });
}
