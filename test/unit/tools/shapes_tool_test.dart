import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/star_shape_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool.dart';

void main() {
  late ShapesTool sut;
  late BoundingBox boundingBox;

  const Offset rectTopLeft = Offset(0, 0);
  const Offset rectBottomRight = Offset(200, 200);
  Paint paint = Paint();

  setUp(() {
    final Rect initialRect = Rect.fromPoints(rectTopLeft, rectBottomRight);
    boundingBox = BoundingBox.fromRect(initialRect);
    sut = ShapesTool(
      type: ToolType.SHAPES,
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      boundingBox: boundingBox,
      shapeType: ShapeType.square,
    );
  });

  test('onCheckmark: should generate HearthShapeCommand', () {
    sut.shapeType = ShapeType.heart;
    sut.onCheckmark(paint);
    final command = sut.commandManager.undoStack.last;
    expect(command.runtimeType, HeartShapeCommand);
  });

  test('onCheckmark: should generate StarShapeCommand', () {
    sut.shapeType = ShapeType.star;
    sut.onCheckmark(paint);
    final command = sut.commandManager.undoStack.last;
    expect(command.runtimeType, StarShapeCommand);
  });

  test('onCheckmark: should generate EllipseShapeCommand', () {
    sut.shapeType = ShapeType.ellipse;
    sut.onCheckmark(paint);
    final command = sut.commandManager.undoStack.last;
    expect(command.runtimeType, EllipseShapeCommand);
  });

  test('onCheckmark: should generate SquareShapeCommand', () {
    sut.shapeType = ShapeType.square;
    sut.onCheckmark(paint);
    final command = sut.commandManager.undoStack.last;
    expect(command.runtimeType, SquareShapeCommand);
  });

  test('onCheckmark: should add command to command manager', () {
    expect(sut.commandManager.undoStack.length, 0);
    sut.onCheckmark(paint);
    expect(sut.commandManager.undoStack.length, 1);
  });
}
