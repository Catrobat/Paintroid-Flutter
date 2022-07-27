import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/image_with_pixel_info.dart';
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

final _testCanvasStateProvider =
    StateNotifierProvider.family<CanvasStateNotifier, CanvasState, CanvasState>(
  (ref, initialState) {
    return CanvasStateNotifier(
      initialState,
      ref.watch(CommandManager.provider),
      ref.watch(GraphicFactory.provider),
    );
  },
);

final _testWorkspaceStateProvider = StateNotifierProvider.family<
    WorkspaceStateNotifier, WorkspaceState, WorkspaceState>(
  (ref, initialState) => WorkspaceStateNotifier(
    initialState,
    ref.watch(CommandManager.provider),
  ),
);

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

  tearDown(() => container.dispose());

  test(
    'Should return image with the workspace export dimensions',
    () async {
      const testCanvasState = CanvasState(size: Size(300, 800));
      const expectedImageSize = Size(108, 192);
      const testWorkspaceState = WorkspaceState(
        isFullscreen: false,
        exportSize: expectedImageSize,
      );
      container = ProviderContainer(
        overrides: [
          CanvasState.provider
              .overrideWithProvider(_testCanvasStateProvider(testCanvasState)),
          WorkspaceState.provider.overrideWithProvider(
              _testWorkspaceStateProvider(testWorkspaceState))
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
      container = ProviderContainer();
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
    const testExportSize = Size(108, 192);
    const testImageSize = Size(50, 50);
    final testImageRect =
        Rect.fromLTWH(0, 0, testImageSize.width, testImageSize.height);
    final testExportRect =
        Rect.fromLTRB(0, 0, testExportSize.width, testExportSize.height);
    late Paint testPaint;
    late MockCanvas mockCanvas;
    late MockCommandManager mockCommandManager;
    late RenderImageForExport sut;

    setUp(() {
      testPaint = Paint();
      mockCanvas = MockCanvas();
      mockCommandManager = MockCommandManager();
      container = ProviderContainer(overrides: [
        GraphicFactory.provider
            .overrideWithValue(FakeGraphicFactory(mockCanvas, testPaint)),
        CommandManager.provider.overrideWithValue(mockCommandManager),
        CanvasState.provider.overrideWithProvider(
            _testCanvasStateProvider(const CanvasState(size: testCanvasSize))),
        WorkspaceState.provider.overrideWithProvider(
            _testWorkspaceStateProvider(const WorkspaceState(
          isFullscreen: false,
          exportSize: testExportSize,
        ))),
      ]);
      sut = container.read(RenderImageForExport.provider);
    });

    test('When transparency is enabled and no image is loaded', () async {
      await sut.call();
      verifyInOrder([
        mockCanvas.scale(testExportSize.width / testCanvasSize.width),
        mockCanvas.clipRect(testExportRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is disabled and no image is loaded', () async {
      await sut.call(keepTransparency: false);
      verifyInOrder([
        mockCanvas.drawPaint(testPaint),
        mockCanvas.scale(testExportSize.width / testCanvasSize.width),
        mockCanvas.clipRect(testExportRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('When transparency is enabled and image is loaded', () async {
      final testImage = await createTestImage(
          width: testImageSize.width.toInt(),
          height: testImageSize.height.toInt());
      container.read(WorkspaceState.provider.notifier).loadImage(testImage);
      await sut.call();
      verifyInOrder([
        mockCanvas.drawImageRect(testImage, testImageRect, testImageRect, any),
        mockCanvas.scale(testImageSize.width / testCanvasSize.width),
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
      container.read(WorkspaceState.provider.notifier).loadImage(testImage);
      await sut.call(keepTransparency: false);
      verifyInOrder([
        mockCanvas.drawPaint(testPaint),
        mockCanvas.drawImageRect(testImage, testImageRect, testImageRect, any),
        mockCanvas.scale(testImageSize.width / testCanvasSize.width),
        mockCanvas.clipRect(testImageRect, doAntiAlias: false),
        mockCommandManager.executeAllCommands(mockCanvas),
      ]);
      verifyNoMoreInteractions(mockCanvas);
      verifyNoMoreInteractions(mockCommandManager);
    });
  });
}
