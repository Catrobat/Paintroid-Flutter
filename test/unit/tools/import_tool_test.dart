import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';

import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/import_tool.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clipboard_command.dart';
import 'package:paintroid/core/providers/object/load_image_from_photo_library.dart';
import 'package:paintroid/core/utils/load_image_failure.dart';

import '../../utils/clipboard_tool_util.dart';
import 'import_tool_test.mocks.dart';

@GenerateMocks([
  BoundingBox,
  CommandManager,
  CommandFactory,
  ClipboardCommand,
  ui.Image,
  LoadImageFromPhotoLibrary,
])
void main() {
  late ImportTool sut;
  late MockBoundingBox boundingBox;
  late MockCommandManager commandManager;
  late MockCommandFactory commandFactory;
  late MockImage mockImage;
  late MockLoadImageFromPhotoLibrary mockPicker;

  setUp(() {
    boundingBox = MockBoundingBox();
    commandManager = MockCommandManager();
    commandFactory = MockCommandFactory();
    mockImage = MockImage();
    mockPicker = MockLoadImageFromPhotoLibrary();

    when(boundingBox.rect).thenReturn(const ui.Rect.fromLTWH(0, 0, 100, 100));
    when(boundingBox.angle).thenReturn(0.0);
    when(boundingBox.currentAction).thenReturn(BoundingBoxAction.none);

    sut = ImportTool(
      commandManager: commandManager,
      commandFactory: commandFactory,
      boundingBox: boundingBox,
      type: ToolType.IMPORT,
    );
  });

  group('image selection', () {
    test('pickImage updates importedImage and boundingBox dimensions on success', () async {
      when(mockImage.width).thenReturn(200);
      when(mockImage.height).thenReturn(150);
      when(mockPicker.call()).thenAnswer((_) async => Result.ok(mockImage));

      await sut.pickImage(mockPicker);

      expect(sut.importedImage, equals(mockImage));
      verify(boundingBox.width = 200.0).called(1);
      verify(boundingBox.height = 150.0).called(1);
      verify(boundingBox.angle = 0.0).called(1);
    });

    test('keeps the current image when image selection fails', () async {
      sut.importedImage = mockImage;
      when(mockPicker.call()).thenAnswer((_) async =>
          const Result.err(LoadImageFailure.permissionDenied));

      await sut.pickImage(mockPicker);

      expect(sut.importedImage, same(mockImage));
      verifyNever(boundingBox.width = any);
      verifyNever(boundingBox.height = any);
    });
  });

  group('bounding box gestures', () {
    test('delegates a complete interaction to the bounding box', () {
      when(boundingBox.determineAction(any)).thenAnswer((_) {
        when(boundingBox.currentAction).thenReturn(BoundingBoxAction.move);
      });

      sut.onDown(ui.Offset.zero, ui.Paint());
      verify(boundingBox.determineAction(ui.Offset.zero)).called(1);

      sut.onDrag(ui.Offset.zero, ui.Paint());
      verify(boundingBox.updateDrag(ui.Offset.zero)).called(1);

      sut.onUp(ui.Offset.zero, ui.Paint());
      verify(boundingBox.endDrag()).called(1);

      sut.onDrag(ui.Offset.zero, ui.Paint());
      verifyNever(boundingBox.updateDrag(any));
    });

    test('ignores a drag when no handle or image is being interacted with', () {
      sut.onDown(ui.Offset.zero, ui.Paint());
      sut.onDrag(ui.Offset.zero, ui.Paint());
      sut.onUp(ui.Offset.zero, ui.Paint());

      verifyNever(boundingBox.updateDrag(any));
      verifyNever(boundingBox.endDrag());
    });
  });

  group('finalization and command integration', () {
    test('does nothing when no image has been selected', () async {
      await sut.onCheckmark(ui.Paint());

      verifyNever(
          commandFactory.createClipboardCommand(any, any, any, any, any));
      verifyNever(commandManager.addGraphicCommand(any));
    });

    test('creates a transformed clipboard command and clears the preview',
        () async {
      final image = await ClipboardIntegrationTestUtils.createTestImage(50, 50);
      sut.importedImage = image;

      final command = MockClipboardCommand();
      when(commandFactory.createClipboardCommand(any, any, any, any, any))
          .thenReturn(command);
      when(command.prepareForRuntime()).thenAnswer((_) async {});

      await sut.onCheckmark(ui.Paint());

      final imageBytes = verify(commandFactory.createClipboardCommand(
        any,
        captureAny,
        const ui.Offset(50, 50),
        2.0,
        0.0,
      )).captured.single as Uint8List;
      expect(imageBytes, isNotEmpty);
      verify(command.prepareForRuntime()).called(1);
      verify(commandManager.addGraphicCommand(command)).called(1);
      expect(sut.importedImage, isNull);
    });
  });
}
