import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/backward_compatibility/kryo_class_registry.dart';
import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/legacy_deserializers.dart';
import 'package:paintroid/core/backward_compatibility/legacy_model_parser.dart';

void main() {
  group('KryoClassRegistry Tests', () {
    test('readClassName should resolve registered class names correctly', () {
      final bytes = Uint8List.fromList([
        0x11,
      ]); // ID 15 + 2 = 17 (SetDimensionCommand)
      final reader = KryoReader(bytes);

      expect(
        KryoClassRegistry.readClassName(reader),
        equals('SetDimensionCommand'),
      );
    });
  });

  group('Legacy Helper Class Deserialization', () {
    test('deserialize Point should resolve x and y', () {
      final bytes = Uint8List.fromList([
        0x0A, 0x00, 0x00, 0x00, // x = 10
        0x14, 0x00, 0x00, 0x00, // y = 20
      ]);
      final reader = KryoReader(bytes);
      final point = LegacyPoint.deserialize(reader);

      expect(point.x, equals(10));
      expect(point.y, equals(20));
    });

    test('deserialize PointF should resolve float coordinates', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0xC0, 0x3F, // x = 1.5
        0x00, 0x00, 0x20, 0x40, // y = 2.5
      ]);
      final reader = KryoReader(bytes);
      final pointF = LegacyPointF.deserialize(reader);

      expect(pointF.x, equals(1.5));
      expect(pointF.y, equals(2.5));
    });

    test('deserialize RectF should resolve bounds', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0x80, 0x3F, // left = 1.0
        0x00, 0x00, 0x00, 0x40, // top = 2.0
        0x00, 0x00, 0x40, 0x40, // right = 3.0
        0x00, 0x00, 0x80, 0x40, // bottom = 4.0
      ]);
      final reader = KryoReader(bytes);
      final rectF = LegacyRectF.deserialize(reader);

      expect(rectF.left, equals(1.0));
      expect(rectF.top, equals(2.0));
      expect(rectF.right, equals(3.0));
      expect(rectF.bottom, equals(4.0));
    });

    test('deserialize Paint should read all properties', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0xFF, 0xFF, // color
        0x00, 0x00, 0xA0, 0x40, // strokeWidth = 5.0
        0x01, 0x00, 0x00, 0x00, // strokeCap = 1 (ROUND)
        0x01, // isAntiAlias = true
        0x01, 0x00, 0x00, 0x00, // style = 1 (STROKE)
        0x01, 0x00, 0x00, 0x00, // strokeJoin = 1 (ROUND)
        0x00, // hadFilter = false
        0xFF, 0x00, 0x00, 0x00, // alpha = 255
      ]);
      final reader = KryoReader(bytes);
      final paint = LegacyPaint.deserialize(reader);

      expect(paint.strokeWidth, equals(5.0));
      expect(paint.strokeCap, equals(1));
      expect(paint.isAntiAlias, isTrue);
      expect(paint.alpha, equals(255));
    });

    test('deserialize ColorHistory should read colors list', () {
      final bytes = Uint8List.fromList([
        0x02, 0x00, 0x00, 0x00, // size = 2
        0xFF, 0x00, 0x00, 0x00, // color 1
        0x00, 0x00, 0xFF, 0x00, // color 2
      ]);
      final reader = KryoReader(bytes);
      final history = LegacyColorHistory.deserialize(reader);

      expect(history.colors.length, equals(2));
      expect(history.colors[0], equals(255));
    });
  });

  group('LegacyCommandManagerModel Deserialization Tests', () {
    test(
      'deserialize should parse SetDimensionCommand and basic list size',
      () {
        final bytes = Uint8List.fromList([
          0x11, // SetDimensionCommand class ID (15 + 2 = 17)
          0x20, 0x03, 0x00, 0x00, // width = 800
          0x58, 0x02, 0x00, 0x00, // height = 600
          0x00, 0x00, 0x00, 0x00, // command list size = 0
        ]);
        final reader = KryoReader(bytes);
        final model = LegacyCommandManagerModel.deserialize(reader);

        expect(model.initialCommand['type'], equals('SetDimensionCommand'));
        expect(model.initialCommand['width'], equals(800));
        expect(model.initialCommand['height'], equals(600));
        expect(model.commands, isEmpty);
      },
    );

    test('deserialize should parse multiple drawing commands', () {
      final bytes = Uint8List.fromList([
        0x11, // SetDimensionCommand (15 + 2 = 17)
        0x20, 0x03, 0x00, 0x00, // width = 800
        0x58, 0x02, 0x00, 0x00, // height = 600
        0x02, 0x00, 0x00, 0x00, // command list size = 2

        0x14, // AddEmptyLayerCommand (18 + 2 = 20) -> [0x14]

        0x15, // SelectLayerCommand (19 + 2 = 21) -> [0x15]
        0x01, 0x00, 0x00, 0x00, // layerIndex = 1
      ]);
      final reader = KryoReader(bytes);
      final model = LegacyCommandManagerModel.deserialize(reader);

      expect(model.commands.length, equals(2));
      expect(model.commands[0]['type'], equals('AddEmptyLayerCommand'));
      expect(model.commands[1]['type'], equals('SelectLayerCommand'));
      expect(model.commands[1]['layerIndex'], equals(1));
    });
  });

  group('Legacy Path and Action Deserialization Tests', () {
    test('deserialize Move action', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0x80, 0x3F, // x = 1.0
        0x00, 0x00, 0x00, 0x40, // y = 2.0
      ]);
      final reader = KryoReader(bytes);
      final move = LegacySerializablePathMove.deserialize(reader);
      expect(move.x, equals(1.0));
      expect(move.y, equals(2.0));
    });

    test('deserialize Line action', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0x00, 0x40, // x = 2.0
        0x00, 0x00, 0x40, 0x40, // y = 3.0
      ]);
      final reader = KryoReader(bytes);
      final line = LegacySerializablePathLine.deserialize(reader);
      expect(line.x, equals(2.0));
      expect(line.y, equals(3.0));
    });

    test('deserialize Quad action', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0x80, 0x3F, // x1 = 1.0
        0x00, 0x00, 0x00, 0x40, // y1 = 2.0
        0x00, 0x00, 0x40, 0x40, // x2 = 3.0
        0x00, 0x00, 0x80, 0x40, // y2 = 4.0
      ]);
      final reader = KryoReader(bytes);
      final quad = LegacySerializablePathQuad.deserialize(reader);
      expect(quad.x1, equals(1.0));
      expect(quad.y1, equals(2.0));
      expect(quad.x2, equals(3.0));
      expect(quad.y2, equals(4.0));
    });

    test('deserialize Cube action', () {
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0x80, 0x3F, // x1 = 1.0
        0x00, 0x00, 0x00, 0x40, // y1 = 2.0
        0x00, 0x00, 0x40, 0x40, // x2 = 3.0
        0x00, 0x00, 0x80, 0x40, // y2 = 4.0
        0x00, 0x00, 0xA0, 0x40, // x3 = 5.0
        0x00, 0x00, 0xC0, 0x40, // y3 = 6.0
      ]);
      final reader = KryoReader(bytes);
      final cube = LegacySerializablePathCube.deserialize(reader);
      expect(cube.x1, equals(1.0));
      expect(cube.y1, equals(2.0));
      expect(cube.x2, equals(3.0));
      expect(cube.y2, equals(4.0));
      expect(cube.x3, equals(5.0));
      expect(cube.y3, equals(6.0));
    });

    test('deserialize Rewind action', () {
      final bytes = Uint8List.fromList([]);
      final reader = KryoReader(bytes);
      final rewind = LegacySerializablePathRewind.deserialize(reader);
      expect(rewind, isNotNull);
    });

    test('deserialize SerializablePath containing actions list', () {
      final bytes = Uint8List.fromList([
        0x02, 0x00, 0x00, 0x00, // size = 2 actions

        0x25, // action 1: SerializablePathMove (35 + 2 = 37 -> 0x25)
        0x00, 0x00, 0x80, 0x3F, // x = 1.0
        0x00, 0x00, 0x00, 0x40, // y = 2.0

        0x26, // action 2: SerializablePathLine (36 + 2 = 38 -> 0x26)
        0x00, 0x00, 0x00, 0x40, // x = 2.0
        0x00, 0x00, 0x40, 0x40, // y = 3.0
      ]);
      final reader = KryoReader(bytes);
      final path = LegacySerializablePath.deserialize(reader);

      expect(path.actions.length, equals(2));
      expect(path.actions[0], isA<LegacySerializablePathMove>());
      expect(path.actions[1], isA<LegacySerializablePathLine>());

      final move = path.actions[0] as LegacySerializablePathMove;
      expect(move.x, equals(1.0));
      expect(move.y, equals(2.0));

      final line = path.actions[1] as LegacySerializablePathLine;
      expect(line.x, equals(2.0));
      expect(line.y, equals(3.0));
    });
  });
}
