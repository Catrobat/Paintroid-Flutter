import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

void main() {
  group('KryoReader Primitives', () {
    test('readByte and readBytes should navigate through stream correctly', () {
      final bytes = Uint8List.fromList([0x10, 0x20, 0x30, 0x40]);
      final reader = KryoReader(bytes);

      expect(reader.position, equals(0));
      expect(reader.remaining, equals(4));
      expect(reader.hasRemaining, isTrue);

      expect(reader.readByte(), equals(0x10));
      expect(reader.position, equals(1));

      final sublist = reader.readBytes(2);
      expect(sublist, equals([0x20, 0x30]));
      expect(reader.position, equals(3));
      expect(reader.remaining, equals(1));

      expect(reader.readByte(), equals(0x40));
      expect(reader.hasRemaining, isFalse);

      expect(() => reader.readByte(), throwsRangeError);
    });

    test('readBoolean should return correct values', () {
      final bytes = Uint8List.fromList([0x00, 0x01, 0xFF]);
      final reader = KryoReader(bytes);

      expect(reader.readBoolean(), isFalse);
      expect(reader.readBoolean(), isTrue);
      expect(reader.readBoolean(), isTrue);
    });

    test('readInt32 and readInt64 should read fixed size values', () {
      // Little-endian fixed representation tests
      final bytes = Uint8List.fromList([
        0x2A, 0x00, 0x00, 0x00, // 42 in 32-bit
        0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 100 in 64-bit
      ]);
      final reader = KryoReader(bytes);

      expect(reader.readInt32(), equals(42));
      expect(reader.readInt64(), equals(100));
    });

    test('readFloat and readDouble should parse IEEE 754 representations', () {
      // Little-endian IEEE 754 representations: 2.5 (float) and 3.14 (double)
      final bytes = Uint8List.fromList([
        0x00, 0x00, 0x20, 0x40,
        0x1F, 0x85, 0xEB, 0x51, 0xB8, 0x1E, 0x09, 0x40,
      ]);
      final reader = KryoReader(bytes);

      expect(reader.readFloat(), equals(2.5));
      expect(reader.readDouble(), closeTo(3.14, 0.0001));
    });
  });

  group('KryoReader VarInts and VarLongs', () {
    test('readVarInt (optimizePositive = true)', () {
      // Varint boundary value tests
      final bytes = Uint8List.fromList([
        0x00, // 0
        0x7F, // 127
        0x80, 0x01, // 128
        0xFF, 0x7F, // 16383
        0x80, 0x80, 0x01, // 16384
      ]);
      final reader = KryoReader(bytes);

      expect(reader.readVarInt(true), equals(0));
      expect(reader.readVarInt(true), equals(127));
      expect(reader.readVarInt(true), equals(128));
      expect(reader.readVarInt(true), equals(16383));
      expect(reader.readVarInt(true), equals(16384));
    });

    test('readVarInt (optimizePositive = false)', () {
      // ZigZag-encoded varint tests
      final bytes = Uint8List.fromList([0x01, 0x02, 0x03, 0x04]);
      final reader = KryoReader(bytes);

      expect(reader.readVarInt(false), equals(-1));
      expect(reader.readVarInt(false), equals(1));
      expect(reader.readVarInt(false), equals(-2));
      expect(reader.readVarInt(false), equals(2));
    });
  });

  group('KryoReader String Parsing', () {
    test(
      'readString should handle null, empty, standard, and optimized ASCII strings',
      () {
        // String format tests including ASCII optimization MSB mask
        final bytes = Uint8List.fromList([
          0x80, // null (Kryo 5 format)
          0x81, // empty string (Kryo 5 format)
          0x43, 0x61, 0xF4, // "Cat" (ASCII optimized: MSB set on 't')
          0x85, 0x44, 0x61, 0x72, 0x74, // "Dart" (Kryo 5 UTF-8/standard format)
        ]);
        final reader = KryoReader(bytes);

        expect(reader.readString(), isNull);
        expect(reader.readString(), equals(''));
        expect(reader.readString(), equals('Cat'));
        expect(reader.readString(), equals('Dart'));
      },
    );
  });
}

