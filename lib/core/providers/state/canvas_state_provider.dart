import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory_provider.dart';
import 'package:paintroid/core/models/loggable_mixin.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/providers/state/canvas_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toast/toast.dart';

part 'canvas_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CanvasStateProvider extends _$CanvasStateProvider with LoggableMixin {
  Size initialCanvasSize = Size.zero;

  @override
  CanvasStateData build() {
    initialCanvasSize = ref.watch(IDeviceService.sizeProvider).when(
          data: (size) => size,
          error: (_, __) => widgets.WidgetsBinding.instance.platformDispatcher
              .views.first.physicalSize,
          loading: () => Size.zero,
        );
    return CanvasStateData(
      size: initialCanvasSize,
      commandManager: ref.watch(commandManagerProvider),
      graphicFactory: ref.watch(graphicFactoryProvider),
      isCachingCommand: false,
    );
  }

  CanvasStateData get currentState => state;

  void setBackgroundImage(Image image) => state = state.copyWith(
        backgroundImage: image,
        size: Size(image.width.toDouble(), image.height.toDouble()),
      );

  void clearBackgroundImageAndResetDimensions() => state = state.copyWith(
        backgroundImage: null,
        size: initialCanvasSize,
      );

  Future<void> updateCachedImage() async {
    state = state.copyWith(isCachingCommand: true);
    final recorder = state.graphicFactory.createPictureRecorder();
    final canvas = state.graphicFactory.createCanvasWithRecorder(recorder);
    final size = state.size;
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    if (state.cachedImage != null) {
      paintImage(
        canvas: canvas,
        rect: bounds,
        image: state.cachedImage!,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      );
    }
    canvas.clipRect(bounds);
    state.commandManager.executeLastCommand(canvas);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    state = state.copyWith(cachedImage: img, isCachingCommand: false);
  }

  Future<void> resetCanvasWithNewCommands(Iterable<Command> commands) async {
    final List<Command> preparedCommands = [];
    for (final command in commands) {
      try {
        await command.prepareForRuntime();
        preparedCommands.add(command);
      } catch (e) {
        Toast.show(
          'Error preparing command ${command.runtimeType} during resetCanvasWithNewCommands: $e',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }
    }

    state.commandManager.clearRedoStack();

    state.commandManager.clearUndoStack(newCommands: preparedCommands);
    if (preparedCommands.isEmpty) {
      state = state.copyWith(cachedImage: null);
    }
    if (commands.isEmpty) {
      state = state.copyWith(cachedImage: null, isCachingCommand: false);
    } else {
      await _executeAllCommandsOnCanvas();
    }
  }

  Future<void> resetCanvasWithExistingCommands() async {
    await _executeAllCommandsOnCanvas();
  }

  Future<void> _executeAllCommandsOnCanvas() async {
    state = state.copyWith(isCachingCommand: true);
    final recorder = state.graphicFactory.createPictureRecorder();
    final canvas = state.graphicFactory.createCanvasWithRecorder(recorder);
    final size = state.size;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    state.commandManager.executeAllCommands(canvas);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    state = state.copyWith(cachedImage: img, isCachingCommand: false);
  }
}
