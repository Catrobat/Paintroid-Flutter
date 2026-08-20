import 'dart:convert';
import 'dart:typed_data';

class KryoReader {
  final Uint8List _bytes;
  int _position = 0;
  final Map<int, String> dynamicClassMap = {};
  int nextDynamicClassId = 56;

  KryoReader(this._bytes);

  int get position => _position;

  set position(int pos) {
    if (pos >= 0 && pos <= _bytes.length) {
      _position = pos;
    }
  }

  bool get hasRemaining => _position < _bytes.length;

  int get remaining => _bytes.length - _position;

  int readByte() {
    if (_position >= _bytes.length) {
      throw RangeError(
        'Index out of bounds: Attempted to read past the end of the byte stream.',
      );
    }
    return _bytes[_position++];
  }

  Uint8List readBytes(int length) {
    if (length < 0) {
      throw ArgumentError('Length cannot be negative.');
    }
    if (_position + length > _bytes.length) {
      throw RangeError(
        'Index out of bounds: Attempted to read $length bytes, but only $remaining are remaining.',
      );
    }
    final result = Uint8List.sublistView(_bytes, _position, _position + length);
    _position += length;
    return result;
  }

  int readInt32({Endian endian = Endian.little}) {
    final bytes = readBytes(4);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt32(0, endian);
  }

  int readInt64({Endian endian = Endian.little}) {
    final bytes = readBytes(8);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt64(0, endian);
  }

  double readFloat({Endian endian = Endian.little}) {
    final bytes = readBytes(4);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getFloat32(0, endian);
  }

  double readDouble({Endian endian = Endian.little}) {
    final bytes = readBytes(8);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getFloat64(0, endian);
  }

  bool readBoolean() {
    return readByte() != 0;
  }

  int readChar({Endian endian = Endian.little}) {
    final bytes = readBytes(2);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint16(0, endian);
  }

  int readVarInt(bool optimizePositive) {
    if (!hasRemaining) {
      throw RangeError(
        'Index out of bounds: No bytes remaining to read varint.',
      );
    }
    int b = readByte();
    int result = b & 0x7F;
    if ((b & 0x80) != 0) {
      b = readByte();
      result |= (b & 0x7F) << 7;
      if ((b & 0x80) != 0) {
        b = readByte();
        result |= (b & 0x7F) << 14;
        if ((b & 0x80) != 0) {
          b = readByte();
          result |= (b & 0x7F) << 21;
          if ((b & 0x80) != 0) {
            b = readByte();
            result |= (b & 0x7F) << 28;
          }
        }
      }
    }
    if (optimizePositive) {
      return result;
    } else {
      // Decode ZigZag encoding for signed integers
      return (result >> 1) ^ -(result & 1);
    }
  }

  int readVarLong(bool optimizePositive) {
    if (!hasRemaining) {
      throw RangeError(
        'Index out of bounds: No bytes remaining to read varlong.',
      );
    }
    int b = readByte();
    int result = b & 0x7F;
    if ((b & 0x80) != 0) {
      b = readByte();
      result |= (b & 0x7F) << 7;
      if ((b & 0x80) != 0) {
        b = readByte();
        result |= (b & 0x7F) << 14;
        if ((b & 0x80) != 0) {
          b = readByte();
          result |= (b & 0x7F) << 21;
          if ((b & 0x80) != 0) {
            b = readByte();
            result |= (b & 0x7F) << 28;
            if ((b & 0x80) != 0) {
              b = readByte();
              result |= (b & 0x7F) << 35;
              if ((b & 0x80) != 0) {
                b = readByte();
                result |= (b & 0x7F) << 42;
                if ((b & 0x80) != 0) {
                  b = readByte();
                  result |= (b & 0x7F) << 49;
                  if ((b & 0x80) != 0) {
                    b = readByte();
                    result |= b << 56;
                  }
                }
              }
            }
          }
        }
      }
    }
    if (optimizePositive) {
      return result;
    } else {
      // Decode ZigZag encoding
      return (result >> 1) ^ -(result & 1);
    }
  }

  String? readString() {
    if (!hasRemaining) return null;
    final int firstByte = _bytes[_position];
    final bool isUtf8OrSpecial = (firstByte & 0x80) != 0;

    if (!isUtf8OrSpecial) {
      // ASCII Optimized string (no length byte, ends with MSB-set character)
      final List<int> asciiBytes = [];
      while (hasRemaining) {
        final int b = readByte();
        if ((b & 0x80) == 0) {
          asciiBytes.add(b);
        } else {
          asciiBytes.add(b & 0x7F);
          break;
        }
      }
      return ascii.decode(asciiBytes);
    } else {
      // Null, empty, or UTF-8 string
      final int first = readByte();
      int result = first & 0x3F;
      if ((first & 0x40) != 0) {
        int shift = 6;
        while (hasRemaining) {
          final int b = readByte();
          result |= (b & 0x7F) << shift;
          if ((b & 0x80) == 0) {
            break;
          }
          shift += 7;
        }
      }

      final int charCount = result;
      if (charCount == 0) {
        return null;
      }
      if (charCount == 1) {
        return '';
      }

      final int byteCount = charCount - 1;
      final bytes = readBytes(byteCount);
      return utf8.decode(bytes, allowMalformed: true);
    }
  }
}
