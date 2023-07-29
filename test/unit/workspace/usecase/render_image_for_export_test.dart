import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/command/src/command_manager_provider.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/graphic_factory_provider.dart';
import 'package:paintroid/core/image_with_pixel_info.dart';
import 'package:paintroid/workspace/src/state/canvas/canvas_state_data.dart';
import 'package:paintroid/workspace/src/state/canvas/canvas_state_provider.dart';
import 'package:paintroid/workspace/workspace.dart';

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

class MockCanvasState1 extends CanvasState {
  @override
  CanvasStateData build() {
    return CanvasStateData(
      size: const Size(108, 192),
      commandManager: MockCommandManager(),
      graphicFactory: FakeGraphicFactory(MockCanvas(), Paint()),
    );
  }
}

class MockCanvasState2 extends CanvasState {
  @override
  CanvasStateData build() {
    return CanvasStateData(
      size: const Size(300, 800),
      commandManager: MockCommandManager(),
      graphicFactory: FakeGraphicFactory(MockCanvas(), Paint()),
    );
  }
}

class FakeGraphicFactory extends GraphicFactory {
  FakeGraphicFactory(this.mockCanvas, [this.paint]);

  final MockCanvas mockCanvas;
  final Paint? paint;

  @override
  PictureRecorder createPictureRecorder() => FakePictureRecorder();

  @override
  Canvas createCanvasWithRecorder(PictureRecorder recorder) => mockCanvas;

  @override
  Paint createPaint() => paint ?? Paint();
}

class FakeGraphicCommand extends Fake implements GraphicCommand {}

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<Canvas>(returnNullOnMissingStub: true),
    MockSpec<CommandManager>(returnNullOnMissingStub: true),
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
    late Paint testPaint;
    late MockCanvas mockCanvas;
    late MockCommandManager mockCommandManager;
    late RenderImageForExport sut;

    setUp(() {
      testPaint = Paint();
      mockCanvas = MockCanvas();
      mockCommandManager = MockCommandManager();
      container = ProviderContainer(overrides: [
        graphicFactoryProvider
            .overrideWithValue(FakeGraphicFactory(mockCanvas, testPaint)),
        commandManagerProvider.overrideWithValue(mockCommandManager),
        canvasStateProvider.overrideWith(MockCanvasState2.new),
      ]);
      sut = container.read(RenderImageForExport.provider);
    });

    test('When transparency is enabled and no image is loaded', () async {
      await sut.call();
      verifyInOrder([
        mockCanvas.clipRect(testCanvasRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is disabled and no image is loaded', () async {
      await sut.call(keepTransparency: false);
      verifyInOrder([
        mockCanvas.drawPaint(testPaint),
        mockCanvas.clipRect(testCanvasRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is enabled and image is loaded', () async {
      final testImage = await createTestImage(
          width: testImageSize.width.toInt(),
          height: testImageSize.height.toInt());
      container
          .read(canvasStateProvider.notifier)
          .setBackgroundImage(testImage);
      await sut.call();
      verifyInOrder([
        mockCanvas.drawImageRect(testImage, testImageRect, testImageRect, any),
        mockCanvas.clipRect(testImageRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is disabled and image is loaded', () async {
      final testImage = await createTestImage(
          width: testImageSize.width.toInt(),
          height: testImageSize.height.toInt());
      when(mockCommandManager.count).thenReturn(0);
      container
          .read(canvasStateProvider.notifier)
          .setBackgroundImage(testImage);
      await sut.call(keepTransparency: false);
      verifyInOrder([
        mockCanvas.drawPaint(testPaint),
        mockCanvas.drawImageRect(testImage, testImageRect, testImageRect, any),
        mockCanvas.clipRect(testImageRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });
  });
}
