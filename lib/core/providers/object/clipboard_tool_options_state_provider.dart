import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:paintroid/core/commands/command_factory/command_factory_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager_provider.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/object/tools/clipboard_tool_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/clipboard_tool_options_state_data.dart';
import 'package:paintroid/core/tools/implementation/clipboard_tool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_tool_options_state_provider.g.dart';

@riverpod
class ClipboardToolOptionsStateProvider
    extends _$ClipboardToolOptionsStateProvider {
  @override
  ClipboardToolOptionsStateData build() {
    final clipboardTool = ref.read(clipboardToolProvider);
    return ClipboardToolOptionsStateData(
      hasCopiedContent: clipboardTool.copiedImageData != null,
    );
  }

  ClipboardTool get _clipboardTool => ref.read(clipboardToolProvider);

  Future<void> performCopy(ui.Image canvasImage) async {
    await _clipboardTool.copy(canvasImage);
    state = state.copyWith(
        hasCopiedContent: _clipboardTool.copiedImageData != null);
    _notifyUpdates();
  }

  Future<void> performPaste(Paint paint) async {
    if (_clipboardTool.copiedImageData != null) {
      await _clipboardTool.paste(paint);
      _notifyUpdates(updateCache: true);
    }
  }

  Future<void> performCut(ui.Image canvasImage) async {
    await _clipboardTool.copy(canvasImage);
    final bool didCopy = _clipboardTool.copiedImageData != null;
    state = state.copyWith(hasCopiedContent: didCopy);

    if (didCopy) {
      final commandFactory = ref.read(commandFactoryProvider);
      final commandManager = ref.read(commandManagerProvider);
      final deleteCommand = commandFactory.createDeleteRegionCommand(
        _clipboardTool.boundingBox.rect,
      );
      commandManager.addGraphicCommand(deleteCommand);
    }

    _notifyUpdates(updateCache: true);
  }

  void clearClipboard() {
    _clipboardTool.clearClipboard();
    state = state.copyWith(hasCopiedContent: false);
    _notifyUpdates();
  }

  void _notifyUpdates({bool updateCache = false}) {
    ref.read(canvasPainterProvider.notifier).repaint();
    if (updateCache) {
      ref.read(canvasStateProvider.notifier).updateCachedImage();
    }
  }
}
