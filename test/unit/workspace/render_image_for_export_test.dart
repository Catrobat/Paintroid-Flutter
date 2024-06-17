// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/models/image_with_pixel_info.dart';
import 'package:paintroid/core/providers/object/render_image_for_export.dart';
import 'package:paintroid/core/providers/state/canvas_state_data.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'render_image_for_export_test.mocks.dart';

class FakePicture extends Fake implements Picture {
  @override
  Future<Image> toImage(int width, int height) =>
      createTestImage(width: width, height: height);
}

class FakePictureRecorder extends Fake implements PictureRecorder {
  @override
  Picture endRecording() => FakePicture();
}

class FakeGraphicCommand extends Fake implements GraphicCommand {}

class MockCanvasState1 extends CanvasStateProvider {
  @override
  CanvasStateData build() {
    return CanvasStateData(
      size: const Size(108, 192),
      commandManager: MockCommandManager(),
      graphicFactory:
          FakeGraphicFactory(MockCanvas(), MockCanvas(), MockCanvas(), Paint()),
    );
  }
}

class MockCanvasState2 extends CanvasStateProvider {
  @override
  CanvasStateData build() {
    return CanvasStateData(
      size: const Size(300, 800),
      commandManager: MockCommandManager(),
      graphicFactory:
          FakeGraphicFactory(MockCanvas(), MockCanvas(), MockCanvas(), Paint()),
    );
  }
}

class MockGraphicsFactoryState extends GraphicFactoryProvider {
  @override
  GraphicFactory build() {
    return fakeGraphicFactory;
  }
}

class MockCommandManagerState extends CommandManagerProvider {
  @override
  CommandManager build() => mockCommandManager;
}

class FakeGraphicFactory extends GraphicFactory {
  FakeGraphicFactory(
      this.backgroundCanvas, this.commandsCanvas, this.combinedCanvas,
      [this.paint]);

  final MockCanvas backgroundCanvas;
  final MockCanvas commandsCanvas;
  final MockCanvas combinedCanvas;
  final Paint? paint;

  @override
  PictureRecorder createPictureRecorder() => FakePictureRecorder();

  @override
  Canvas createCanvasWithRecorder(PictureRecorder recorder) {
    fakeGraphicFactoryCallCount++;
    switch (fakeGraphicFactoryCallCount) {
      case 1:
        return backgroundCanvas;
      case 2:
        return commandsCanvas;
      case 3:
        return combinedCanvas;
      default:
        return MockCanvas();
    }
  }

  @override
  Paint createPaint() => paint ?? Paint();
}

final mockBackgroundCanvas = MockCanvas();
final mockCommandsCanvas = MockCanvas();
final mockCombinedCanvas = MockCanvas();
final mockCommandManager = MockCommandManager();
final testPaint = Paint();

int fakeGraphicFactoryCallCount = 0;

final fakeGraphicFactory = FakeGraphicFactory(
  mockBackgroundCanvas,
  mockCommandsCanvas,
  mockCombinedCanvas,
  testPaint,
);

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<Canvas>(),
    MockSpec<CommandManager>(),
  ],
)
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  setUp(() {
    container = ProviderContainer(
      overrides: [
        canvasStateProvider.overrideWith(MockCanvasState1.new),
      ],
    );
  });

  tearDown(() => container.dispose());

  test(
    'Should return image with the workspace export dimensions',
    () async {
      const expectedImageSize = Size(108, 192);
      container = ProviderContainer(
        overrides: [
          canvasStateProvider.overrideWith(MockCanvasState1.new),
        ],
      );

      final sut = container.read(RenderImageForExport.provider);
      final img = await sut.call();
      expect(img.width, equals(expectedImageSize.width));
      expect(img.height, equals(expectedImageSize.height));
    },
  );

  test(
    'Should paint the background white when keepTransparency is true',
    () async {
      final sut = container.read(RenderImageForExport.provider);
      final img = await sut.call(keepTransparency: false);
      final image = await ImageWithPixelInfo.initialize(img);
      const expectedColor = Color(0xFFFFFFFF);
      for (final alignment in AlignmentValues.values) {
        expect(image.pixelColorFor(alignment), equals(expectedColor));
      }
    },
  );

  group('Should paint on canvas in the correct order', () {
    const testCanvasSize = Size(300, 800);
    const testImageSize = Size(50, 50);
    final testImageRect =
        Rect.fromLTWH(0, 0, testImageSize.width, testImageSize.height);
    final testCanvasRect =
        Rect.fromLTRB(0, 0, testCanvasSize.width, testCanvasSize.height);

    late RenderImageForExport sut;

    setUp(() {
      container = ProviderContainer(overrides: [
        graphicFactoryProvider.overrideWith(MockGraphicsFactoryState.new),
        commandManagerProvider.overrideWith(MockCommandManagerState.new),
        canvasStateProvider.overrideWith(MockCanvasState2.new),
      ]);
      sut = container.read(RenderImageForExport.provider);
    });

    test('When transparency is enabled and no image is loaded', () async {
      fakeGraphicFactoryCallCount = 0;
      await sut.call();
      verifyInOrder([
        mockCommandsCanvas.clipRect(testCanvasRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCommandsCanvas),
        mockCombinedCanvas.drawImage(any, any, any),
        mockCombinedCanvas.drawImage(any, any, any),
      ]);
      verifyZeroInteractions(mockBackgroundCanvas);
      verifyNoMoreInteractions(mockCommandsCanvas);
      verifyNoMoreInteractions(mockCombinedCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is disabled and no image is loaded', () async {
      fakeGraphicFactoryCallCount = 0;
      await sut.call(keepTransparency: false);

      verifyInOrder([
        mockBackgroundCanvas.drawPaint(testPaint),
        mockCommandsCanvas.clipRect(testCanvasRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCommandsCanvas),
        mockCombinedCanvas.drawImage(any, any, any),
        mockCombinedCanvas.drawImage(any, any, any),
      ]);
      verifyNoMoreInteractions(mockBackgroundCanvas);
      verifyNoMoreInteractions(mockCommandsCanvas);
      verifyNoMoreInteractions(mockCombinedCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is enabled and image is loaded', () async {
      fakeGraphicFactoryCallCount = 0;
      final testImage = await createTestImage(
          width: testImageSize.width.toInt(),
          height: testImageSize.height.toInt());
      container
          .read(canvasStateProvider.notifier)
          .setBackgroundImage(testImage);
      await sut.call();
      verifyInOrder([
        mockBackgroundCanvas.drawImageRect(
            testImage, testImageRect, testImageRect, any),
        mockCommandsCanvas.clipRect(testImageRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCommandsCanvas),
        mockCombinedCanvas.drawImage(any, any, any),
        mockCombinedCanvas.drawImage(any, any, any),
      ]);
      verifyNoMoreInteractions(mockBackgroundCanvas);
      verifyNoMoreInteractions(mockCommandsCanvas);
      verifyNoMoreInteractions(mockCombinedCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is disabled and image is loaded', () async {
      fakeGraphicFactoryCallCount = 0;
      final testImage = await createTestImage(
          width: testImageSize.width.toInt(),
          height: testImageSize.height.toInt());
      when(mockCommandManager.undoStack.length).thenReturn(0);
      container
          .read(canvasStateProvider.notifier)
          .setBackgroundImage(testImage);
      await sut.call(keepTransparency: false);
      verifyInOrder([
        mockBackgroundCanvas.drawPaint(testPaint),
        mockBackgroundCanvas.drawImageRect(
            testImage, testImageRect, testImageRect, any),
        mockCommandsCanvas.clipRect(testImageRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCommandsCanvas),
        mockCombinedCanvas.drawImage(any, any, any),
        mockCombinedCanvas.drawImage(any, any, any),
      ]);
      verifyNoMoreInteractions(mockBackgroundCanvas);
      verifyNoMoreInteractions(mockCommandsCanvas);
      verifyNoMoreInteractions(mockCombinedCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });
  });
}
