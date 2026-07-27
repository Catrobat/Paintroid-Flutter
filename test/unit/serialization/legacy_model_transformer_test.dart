import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart' show Offset, Rect, Color;
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clipboard_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/delete_region_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/backward_compatibility/models/models.dart';
import 'package:paintroid/core/backward_compatibility/legacy_model_parser.dart';
import 'package:paintroid/core/backward_compatibility/legacy_model_transformer.dart';

void main() {
  group('LegacyModelTransformer Tests', () {
    test('transform basic model with dimensions and custom paint options', () {
      final initialCommand = {
        'type': 'SetDimensionCommand',
        'width': 1024,
        'height': 768,
      };

      final legacyPaint = LegacyPaint(
        color: 0xFF00FF00,
        strokeWidth: 4.5,
        strokeCap: 1, // ROUND
        isAntiAlias: true,
        style: 1, // STROKE
        strokeJoin: 1, // ROUND
        hadFilter: false,
        alpha: 255,
      );

      final legacyPath = LegacySerializablePath([
        LegacySerializablePathMove(10.0, 20.0),
        LegacySerializablePathLine(30.0, 40.0),
      ]);

      final legacyCmd = {
        'type': 'PathCommand',
        'paint': legacyPaint,
        'path': legacyPath,
      };

      final model = LegacyCommandManagerModel(
        initialCommand: initialCommand,
        commands: [legacyCmd],
      );

      final catrobatImage = LegacyModelTransformer.transform(model);

      expect(catrobatImage.width, equals(1024));
      expect(catrobatImage.height, equals(768));
      expect(catrobatImage.commands.length, equals(1));
      expect(catrobatImage.commands.first, isA<PathCommand>());

      final pathCmd = catrobatImage.commands.first as PathCommand;
      expect(pathCmd.paint.color, equals(const Color(0xFF00FF00)));
      expect(pathCmd.paint.strokeWidth, equals(4.5));
      expect(pathCmd.path.actions.length, equals(2));
      expect(pathCmd.path.actions[0], isA<MoveToAction>());
      expect(pathCmd.path.actions[1], isA<LineToAction>());
    });

    test('transform SprayCommand', () {
      final legacyPaint = LegacyPaint(
        color: 0xFF0000FF,
        strokeWidth: 1.0,
        strokeCap: 1,
        isAntiAlias: true,
        style: 0, // FILL
        strokeJoin: 1,
        hadFilter: false,
        alpha: 128,
      );

      final legacyCmd = {
        'type': 'SprayCommand',
        'paint': legacyPaint,
        'sprayedPoints': [10.0, 20.0, 30.0, 40.0],
      };

      final model = LegacyCommandManagerModel(
        initialCommand: {
          'type': 'SetDimensionCommand',
          'width': 800,
          'height': 600,
        },
        commands: [legacyCmd],
      );

      final image = LegacyModelTransformer.transform(model);

      expect(image.commands.length, equals(1));
      expect(image.commands.first, isA<SprayCommand>());

      final spray = image.commands.first as SprayCommand;
      expect(spray.points.length, equals(2));
      expect(spray.points[0], equals(const Offset(10.0, 20.0)));
      expect(spray.points[1], equals(const Offset(30.0, 40.0)));
    });

    test('transform GeometricFillCommand shapes', () {
      final legacyPaint = LegacyPaint(
        color: 0xFFFF0000,
        strokeWidth: 2.0,
        strokeCap: 1,
        isAntiAlias: true,
        style: 1, // STROKE
        strokeJoin: 1,
        hadFilter: false,
        alpha: 255,
      );

      final legacyRect = LegacyRectF(-20.0, -20.0, 20.0, 20.0);

      final legacyCmd1 = {
        'type': 'GeometricFillCommand',
        'shapeDrawable': 'OvalDrawable',
        'pointX': 30,
        'pointY': 40,
        'boxRect': legacyRect,
        'boxRotation': 0.5,
        'paint': legacyPaint,
      };

      final legacyCmd2 = {
        'type': 'GeometricFillCommand',
        'shapeDrawable': 'RectangleDrawable',
        'pointX': 30,
        'pointY': 40,
        'boxRect': legacyRect,
        'boxRotation': 1.2,
        'paint': legacyPaint,
      };

      final model = LegacyCommandManagerModel(
        initialCommand: {
          'type': 'SetDimensionCommand',
          'width': 800,
          'height': 600,
        },
        commands: [legacyCmd2, legacyCmd1],
      );

      final image = LegacyModelTransformer.transform(model);
      final commands = image.commands.toList();

      expect(commands.length, equals(2));
      expect(commands[0], isA<EllipseShapeCommand>());
      expect(commands[1], isA<SquareShapeCommand>());

      final oval = commands[0] as EllipseShapeCommand;
      expect(oval.radiusX, equals(40.0)); // width
      expect(oval.radiusY, equals(40.0)); // height
      expect(oval.center, equals(const Offset(30.0, 40.0)));
      expect(oval.angle, equals(0.5));

      final rect = commands[1] as SquareShapeCommand;
      Offset rotateAndShift(double x, double y, double angle, Offset center) {
        final cosA = math.cos(angle);
        final sinA = math.sin(angle);
        final rx = x * cosA - y * sinA;
        final ry = x * sinA + y * cosA;
        return Offset(rx, ry) + center;
      }

      final expectedCenter = const Offset(30.0, 40.0);
      expect(
        rect.topLeft,
        equals(rotateAndShift(-20.0, -20.0, 1.2, expectedCenter)),
      );
      expect(
        rect.topRight,
        equals(rotateAndShift(20.0, -20.0, 1.2, expectedCenter)),
      );
      expect(
        rect.bottomLeft,
        equals(rotateAndShift(-20.0, 20.0, 1.2, expectedCenter)),
      );
      expect(
        rect.bottomRight,
        equals(rotateAndShift(20.0, 20.0, 1.2, expectedCenter)),
      );
    });

    test('transform ClipboardCommand and CutCommand', () {
      final pngHeader = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
        0x00, 0x00, 0x00, 0x0D, // IHDR length
        0x49, 0x48, 0x44, 0x52, // IHDR
        0x00, 0x00, 0x00, 0x64, // width = 100
        0x00, 0x00, 0x00, 0x64, // height = 100
        0x08, 0x02, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
      ]);

      final legacyClipboard = {
        'type': 'ClipboardCommand',
        'bitmap': pngHeader,
        'coordinates': LegacyPoint(150, 250),
        'width': 150.0,
        'height': 150.0,
        'rotation': 0.7,
      };

      final legacyCut = {
        'type': 'CutCommand',
        'position': LegacyPoint(300, 400),
        'boxWidth': 80.0,
        'boxHeight': 60.0,
        'boxRotation': 0.0,
      };

      final model = LegacyCommandManagerModel(
        initialCommand: {
          'type': 'SetDimensionCommand',
          'width': 800,
          'height': 600,
        },
        commands: [legacyCut, legacyClipboard],
      );

      final image = LegacyModelTransformer.transform(model);
      final commands = image.commands.toList();

      expect(commands.length, equals(2));
      expect(commands[0], isA<ClipboardCommand>());
      expect(commands[1], isA<DeleteRegionCommand>());

      final clipboard = commands[0] as ClipboardCommand;
      expect(clipboard.offset, equals(const Offset(150.0, 250.0)));
      expect(clipboard.scale, equals(1.5)); // 150 / 100
      expect(clipboard.rotation, equals(0.7));

      final cut = commands[1] as DeleteRegionCommand;
      expect(cut.region, equals(const Rect.fromLTWH(260.0, 370.0, 80.0, 60.0)));
    });

    test('transform layer state commands and load layer list', () {
      final pngHeader = Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x64,
        0x00,
        0x00,
        0x00,
        0x64,
        0x08,
        0x02,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
      ]);

      final legacyLoadLayers = {
        'type': 'LoadLayerListCommand',
        'layers': [
          {'bitmap': pngHeader, 'opacity': 128},
          {'bitmap': pngHeader, 'opacity': 255},
        ],
      };

      final legacyAddEmpty = {'type': 'AddEmptyLayerCommand'};
      final legacySelect = {'type': 'SelectLayerCommand', 'layerIndex': 1};
      final legacyReorder = {
        'type': 'ReorderLayersCommand',
        'fromIndex': 0,
        'toIndex': 1,
      };
      final legacyRemove = {'type': 'RemoveLayerCommand', 'layerIndex': 0};
      final legacyOpacity = {
        'type': 'LayerOpacityCommand',
        'layerIndex': 1,
        'opacity': 0.5,
      };

      final model = LegacyCommandManagerModel(
        initialCommand: {
          'type': 'SetDimensionCommand',
          'width': 800,
          'height': 600,
        },
        commands: [
          legacyLoadLayers,
          legacyAddEmpty,
          legacySelect,
          legacyReorder,
          legacyRemove,
          legacyOpacity,
        ],
      );

      final image = LegacyModelTransformer.transform(model);
      final commands = image.commands.toList();

      expect(commands.length, equals(2));
      expect(commands[0], isA<ClipboardCommand>());
      expect(commands[1], isA<ClipboardCommand>());

      final layer1 = commands[0] as ClipboardCommand;
      expect(layer1.offset, equals(Offset.zero));
      expect(layer1.scale, equals(1.0));
      expect(layer1.rotation, equals(0.0));
      expect(layer1.paint.color.a, closeTo(128 / 255, 0.01));

      final layer2 = commands[1] as ClipboardCommand;
      expect(layer2.paint.color.a, equals(1.0));
    });

    test(
      'transform canvas state commands: Rotate, Flip, Crop, Resize, Reset',
      () {
        final legacyPaint = LegacyPaint(
          color: 0xFF00FF00,
          strokeWidth: 4.5,
          strokeCap: 1,
          isAntiAlias: true,
          style: 1,
          strokeJoin: 1,
          hadFilter: false,
          alpha: 255,
        );

        final legacyPath = LegacySerializablePath([
          LegacySerializablePathMove(10.0, 20.0),
        ]);

        final legacyPathCmd = {
          'type': 'PathCommand',
          'paint': legacyPaint,
          'path': legacyPath,
        };

        final legacyRotate = {'type': 'RotateCommand', 'rotateDirection': 1};

        final legacyFlip = {'type': 'FlipCommand', 'flipDirection': 1};

        final legacyCrop = {
          'type': 'CropCommand',
          'coordinateXLeft': 5,
          'coordinateYTop': 5,
          'coordinateXRight': 55,
          'coordinateYBottom': 55,
        };

        final legacyResize = {
          'type': 'ResizeCommand',
          'width': 100,
          'height': 100,
        };

        final model = LegacyCommandManagerModel(
          initialCommand: {
            'type': 'SetDimensionCommand',
            'width': 100,
            'height': 200,
          },
          commands: [
            legacyResize,
            legacyCrop,
            legacyFlip,
            legacyRotate,
            legacyPathCmd,
          ],
        );

        final image = LegacyModelTransformer.transform(model);
        expect(image.width, equals(100));
        expect(image.height, equals(100));

        final commands = image.commands.toList();
        expect(commands.length, equals(1));
        expect(commands[0], isA<PathCommand>());

        final pathCmd = commands[0] as PathCommand;
        expect(pathCmd.path.actions.length, equals(1));
        final moveAction = pathCmd.path.actions[0] as MoveToAction;
        expect(moveAction.x, closeTo(30.0, 0.01));
        expect(moveAction.y, closeTo(10.0, 0.01));

        // Test ResetCommand
        final modelReset = LegacyCommandManagerModel(
          initialCommand: {
            'type': 'SetDimensionCommand',
            'width': 100,
            'height': 100,
          },
          commands: [
            {'type': 'ResetCommand'},
            legacyPathCmd,
          ],
        );
        final imageReset = LegacyModelTransformer.transform(modelReset);
        expect(imageReset.commands.isEmpty, isTrue);
      },
    );
  });
}
