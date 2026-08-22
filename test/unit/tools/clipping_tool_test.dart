import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:mockito/annotations.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clip_area_command.dart';
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
    test('[CLIPPING_TOOL]: initializes pathToDraw and resets canvas', () {
      when(clippingToolState.hasActiveClipPath).thenReturn(false);
      clippingTool.onDown(const Offset(10, 20), paint);

      verify(graphicFactory.createPathWithActionHistory()).called(1);
      verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
      verifyNever(commandManager.addGraphicCommand(any));
    });

    test(
        '[CLIPPING_TOOL]: clears existing path state when active clip path exists',
        () {
      when(clippingToolState.hasActiveClipPath).thenReturn(true);
      clippingTool.onDown(const Offset(30, 40), paint);

      verify(clippingToolState.clearClipPath()).called(1);
      verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
      verify(graphicFactory.createPathWithActionHistory()).called(1);
    });
  });

  test('[CLIPPING_TOOL]: onUp finalizes path and updates cached image', () async {
    final actions = <PathAction>[MoveToAction(5, 5)];
    when(pathMock.actions).thenReturn(actions);
    when(pathMock.lineTo(any, any)).thenAnswer((realInvocation) {
      actions.add(LineToAction(
          realInvocation.positionalArguments[0], realInvocation.positionalArguments[1]));
    });

    clippingTool.onDown(const Offset(5, 5), paint);

    clearInteractions(clippingToolState);
    clearInteractions(canvasStateProvider);

    await clippingTool.onUp(const Offset(15, 15), paint);

    verify(pathMock.lineTo(15, 15)).called(1);
    verify(pathMock.close()).called(1);
    verify(clippingToolState.setHasActiveClipPath(true)).called(1);
    verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
    verify(canvasStateProvider.updateCachedImage()).called(1);
  });

  test('[CLIPPING_TOOL]: onCancel stops drawing but keeps path if not drawing', () {
    clippingTool.onDown(const Offset(1, 1), paint);
    clippingTool.onCancel();

    expect(clippingTool.pathToDraw, isNotNull);
  });

  test('[CLIPPING_TOOL]: onCheckmark finalizes the clip area and resets path', () {
    when(pathMock.actions).thenReturn([MoveToAction(0, 0), LineToAction(1, 1)]);

    clippingTool.onDown(const Offset(0, 0), paint);
    clippingTool.onUp(const Offset(1, 1), paint);

    clearInteractions(commandManager);
    clearInteractions(commandFactory);
    clearInteractions(clippingToolState);
    clearInteractions(canvasStateProvider);

    when(clippingToolState.hasActiveClipPath).thenReturn(true);

    clippingTool.onCheckmark(paint);

    verify(clippingToolState.clearClipPath()).called(1);
    verify(commandFactory.createClipAreaCommand(pathMock, paint)).called(1);

    final capturedAdd =
        verify(commandManager.addGraphicCommand(captureAny)).captured;
    expect(capturedAdd.single, isA<ClipAreaCommand>());

    verify(canvasStateProvider.resetCanvasWithExistingCommands()).called(1);
    expect(clippingTool.pathToDraw, isNull);
  });
}
