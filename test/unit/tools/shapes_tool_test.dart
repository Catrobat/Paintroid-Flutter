import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/circle_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/rectangle_shape_command.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/shape_type.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/shapes_tool.dart';

void main() {
  late ShapesTool sut;
  late BoundingBox boundingBox;

  const Offset topLeft = Offset(0, 0);
  const Offset topRight = Offset(200, 0);
  const Offset bottomLeft = Offset(0, 200);
  const Offset bottomRight = Offset(200, 200);
  Paint paint = Paint();

  setUp(() {
    boundingBox = BoundingBox(topLeft, topRight, bottomLeft, bottomRight);
    sut = ShapesTool(
      type: ToolType.SHAPES,
      commandFactory: const CommandFactory(),
      commandManager: CommandManager(),
      boundingBox: boundingBox,
      isRotating: false,
      shapeType: ShapeType.rectangle,
    );
  });

  test('onCheckmark: should generate CircleShapeCommand', () {
    sut.shapeType = ShapeType.circle;
    sut.onCheckmark(paint);
    final command = sut.commandManager.undoStack.last;
    expect(command.runtimeType, CircleShapeCommand);
  });

  test('onCheckmark: should generate RectangleShapeCommand', () {
    sut.shapeType = ShapeType.rectangle;
    sut.onCheckmark(paint);
    final command = sut.commandManager.undoStack.last;
    expect(command.runtimeType, RectangleShapeCommand);
  });

  test('onCheckmark: should add command to command manager', () {
    expect(sut.commandManager.undoStack.length, 0);
    sut.onCheckmark(paint);
    expect(sut.commandManager.undoStack.length, 1);
  });
}
