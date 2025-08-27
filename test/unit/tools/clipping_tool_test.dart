import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:mockito/annotations.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clip_area_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clip_path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/tools/implementation/clipping_tool.dart';
import 'package:paintroid/core/providers/object/tools/clipping_tool_state_provider.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';

import 'clipping_tool_test.mocks.dart';

@GenerateMocks([
  CommandManager,
  CommandFactory,
  GraphicFactory,
  GraphicCommand,
  CanvasStateProvider,
  ClippingToolState,
  PathWithActionHistory,
  ClipPathCommand,
  ClipAreaCommand,
])
void main() {
  late MockCommandManager commandManager;
  late MockCommandFactory commandFactory;
  late MockGraphicFactory graphicFactory;
  late MockCanvasStateProvider canvasStateProvider;
  late MockClippingToolState clippingToolState;
  late MockPathWithActionHistory pathMock;
  late ClippingTool clippingTool;
  late Paint paint;

  setUp(() {
    commandManager = MockCommandManager();
    commandFactory = MockCommandFactory();
    graphicFactory = MockGraphicFactory();
    canvasStateProvider = MockCanvasStateProvider();
    clippingToolState = MockClippingToolState();
    pathMock = MockPathWithActionHistory();
    paint = Paint();

    when(graphicFactory.createPathWithActionHistory()).thenReturn(pathMock);

    when(commandFactory.createClipPathCommand(any, any,
            startPoint: anyNamed('startPoint'), endPoint: anyNamed('endPoint')))
        .thenAnswer((_) => MockClipPathCommand());
    when(commandFactory.createClipPathCommand(any, any))
        .thenAnswer((_) => MockClipPathCommand());
    when(commandFactory.createClipAreaCommand(any, any))
        .thenAnswer((_) => MockClipAreaCommand());

    when(clippingToolState.hasActiveClipPath).thenReturn(false);
    when(pathMock.actions).thenReturn([MoveToAction(0, 0)]);

    clippingTool = ClippingTool(
      commandFactory: commandFactory,
      commandManager: commandManager,
      graphicFactory: graphicFactory,
      clippingToolState: clippingToolState,
      canvasStateProvider: canvasStateProvider,
    );
  });

  group('[CLIPPING_TOOL]: onDown', () {
    test(
        '[CLIPPING_TOOL]: creates a live drawing command when no active clip path',
        () {
      when(clippingToolState.hasActiveClipPath).thenReturn(false);
      clippingTool.onDown(const Offset(10, 20), paint);

      verify(graphicFactory.createPathWithActionHistory()).called(1);
      verify(commandFactory.createClipPathCommand(pathMock, paint)).called(1);
      final captured =
          verify(commandManager.addGraphicCommand(captureAny)).captured;
      expect(captured.single, isA<ClipPathCommand>());

      verifyNever(commandManager.removeCommand(any));
      verifyNever(canvasStateProvider.resetCanvasWithExistingCommands());
    });

    test(
        '[CLIPPING_TOOL]: clears existing preview and creates live drawing command when active clip path exists',
        () {
      clippingTool.onDown(const Offset(5, 5), paint);
      clippingTool.onUp(const Offset(10, 10), paint);

      clearInteractions(commandManager);
      clearInteractions(commandFactory);
      clearInteractions(graphicFactory);
      clearInteractions(canvasStateProvider);
      clearInteractions(clippingToolState);

      when(graphicFactory.createPathWithActionHistory()).thenReturn(pathMock);
      when(commandFactory.createClipPathCommand(any, any))
          .thenAnswer((_) => MockClipPathCommand());
      when(clippingToolState.hasActiveClipPath).thenReturn(true);

      clippingTool.onDown(const Offset(30, 40), paint);

      final capturedRemove =
          verify(commandManager.removeCommand(captureAny)).captured;
      expect(capturedRemove.single, isA<ClipPathCommand>());

      verify(clippingToolState.clearClipPath()).called(1);
      verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);

      verify(graphicFactory.createPathWithActionHistory()).called(1);
      verify(commandFactory.createClipPathCommand(pathMock, paint)).called(1);

      final capturedAdd =
          verify(commandManager.addGraphicCommand(captureAny)).captured;
      expect(capturedAdd.single, isA<ClipPathCommand>());
    });
  });

  test(
      '[CLIPPING_TOOL]: onUp removes live command, creates and adds preview command',
      () {
    when(pathMock.actions).thenReturn([MoveToAction(5, 5)]);

    clippingTool.onDown(const Offset(5, 5), paint);

    clearInteractions(commandManager);
    clearInteractions(clippingToolState);
    clearInteractions(canvasStateProvider);
    clearInteractions(commandFactory);

    when(commandFactory.createClipPathCommand(any, any,
            startPoint: anyNamed('startPoint'), endPoint: anyNamed('endPoint')))
        .thenAnswer((_) => MockClipPathCommand());

    clippingTool.onUp(const Offset(15, 15), paint);

    final capturedRemove =
        verify(commandManager.removeCommand(captureAny)).captured;
    expect(capturedRemove.single, isA<ClipPathCommand>());

    verify(commandFactory.createClipPathCommand(pathMock, paint,
            startPoint: anyNamed('startPoint'), endPoint: anyNamed('endPoint')))
        .called(1);
    final capturedAdd =
        verify(commandManager.addGraphicCommand(captureAny)).captured;
    expect(capturedAdd.single, isA<ClipPathCommand>());

    verify(clippingToolState.setHasActiveClipPath(true)).called(1);
    verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
    verify(canvasStateProvider.updateCachedImage()).called(1);
  });

  test('[CLIPPING_TOOL]: onCancel clears live and preview commands', () {
    clippingTool.onDown(const Offset(1, 1), paint);
    clippingTool.onUp(const Offset(2, 2), paint);

    clearInteractions(commandManager);
    clearInteractions(clippingToolState);
    clearInteractions(canvasStateProvider);

    when(clippingToolState.hasActiveClipPath).thenReturn(true);

    clippingTool.onCancel();

    final capturedRemove =
        verify(commandManager.removeCommand(captureAny)).captured;
    expect(capturedRemove.single, isA<ClipPathCommand>());

    verify(clippingToolState.clearClipPath()).called(1);
    verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
  });

  test('[CLIPPING_TOOL]: onCheckmark finalizes the clip area', () {
    when(pathMock.actions).thenReturn([MoveToAction(0, 0), LineToAction(1, 1)]);

    clippingTool.onDown(const Offset(0, 0), paint);
    clippingTool.onUp(const Offset(1, 1), paint);

    clearInteractions(commandManager);
    clearInteractions(commandFactory);
    clearInteractions(clippingToolState);
    clearInteractions(canvasStateProvider);

    when(commandFactory.createClipAreaCommand(any, any))
        .thenAnswer((_) => MockClipAreaCommand());
    when(clippingToolState.hasActiveClipPath).thenReturn(true);

    clippingTool.onCheckmark(paint);

    final capturedRemove =
        verify(commandManager.removeCommand(captureAny)).captured;
    expect(capturedRemove.single, isA<ClipPathCommand>());

    verify(clippingToolState.clearClipPath()).called(1);
    verify(commandFactory.createClipAreaCommand(pathMock, paint)).called(1);

    final capturedAdd =
        verify(commandManager.addGraphicCommand(captureAny)).captured;
    expect(capturedAdd.single, isA<ClipAreaCommand>());

    verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
  });
}
