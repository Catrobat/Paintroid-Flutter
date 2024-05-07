// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/hand_tool.dart';
import 'hand_tool_test.mocks.dart';

@GenerateMocks([
  Paint,
  CommandManager,
  CommandFactory,
])
void main() {
  late MockPaint mockPaint;
  late MockCommandFactory mockCommandFactory;
  late MockCommandManager mockCommandManager;

  late HandTool sut;
  const Offset offset = Offset(10, 10);

  setUp(() {
    mockPaint = MockPaint();
    mockCommandFactory = MockCommandFactory();
    mockCommandManager = MockCommandManager();

    sut = HandTool(
      paint: mockPaint,
      commandFactory: mockCommandFactory,
      commandManager: mockCommandManager,
    );
  });

  group('HandTool Tests', () {
    test('onDown should not interact with any dependencies', () {
      sut.onDown(offset);

      verifyNoMoreInteractions(mockPaint);
      verifyNoMoreInteractions(mockCommandFactory);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('onDrag should not interact with any dependencies', () {
      sut.onDrag(offset);

      verifyNoMoreInteractions(mockPaint);
      verifyNoMoreInteractions(mockCommandFactory);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('onUp should not interact with any dependencies', () {
      sut.onUp(offset);

      verifyNoMoreInteractions(mockPaint);
      verifyNoMoreInteractions(mockCommandFactory);
      verifyNoMoreInteractions(mockCommandManager);
    });

    test('onCancel should not interact with any dependencies', () {
      sut.onCancel();

      verifyNoMoreInteractions(mockPaint);
      verifyNoMoreInteractions(mockCommandFactory);
      verifyNoMoreInteractions(mockCommandManager);
    });
  });

  test('Should return Hand as ToolType', () {
    expect(sut.type, ToolType.HAND);
  });
}
