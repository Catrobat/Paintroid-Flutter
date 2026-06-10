import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/legacy_deserializers.dart';

class KryoClassRegistry {
  static const int baseRegistrationId = 9;

  static const Map<int, String> classMap = {
    9: 'Command',
    10: 'CompositeCommand',
    11: 'FloatArray',
    12: 'PointF',
    13: 'Point',
    14: 'CommandManagerModel',
    15: 'SetDimensionCommand',
    16: 'SprayCommand',
    17: 'Paint',
    18: 'AddEmptyLayerCommand',
    19: 'SelectLayerCommand',
    20: 'LoadCommand',
    21: 'TextToolCommand',
    22: 'StringArray',
    23: 'FillCommand',
    24: 'FlipCommand',
    25: 'CropCommand',
    26: 'CutCommand',
    27: 'ResizeCommand',
    28: 'RotateCommand',
    29: 'ResetCommand',
    30: 'ReorderLayersCommand',
    31: 'RemoveLayerCommand',
    32: 'MergeLayersCommand',
    33: 'PathCommand',
    34: 'SerializablePath',
    35: 'SerializablePathMove',
    36: 'SerializablePathLine',
    37: 'SerializablePathQuad',
    38: 'SerializablePathRewind',
    39: 'LoadLayerListCommand',
    40: 'GeometricFillCommand',
    41: 'HeartDrawable',
    42: 'OvalDrawable',
    43: 'RectangleDrawable',
    44: 'StarDrawable',
    45: 'ShapeDrawable',
    46: 'RectF',
    47: 'ClipboardCommand',
    48: 'SerializableTypeface',
    49: 'PointCommand',
    50: 'SerializablePathCube',
    51: 'Bitmap',
    52: 'SmudgePathCommand',
    53: 'ColorHistory',
    54: 'ClippingCommand',
    55: 'LayerOpacityCommand',
  };

  /// Decodes a class registration ID from the stream and resolves its class name.
  /// Kryo writes class references as: registrationID + 2 (0 represents null).
  static String? readClassName(KryoReader reader) {
    final int encodedId = reader.readVarInt(true);
    if (encodedId == 0) {
      return null;
    }
    final int classId = encodedId - 2;
    final className = classMap[classId];
    if (className == null) {
      throw FormatException(
        'Unknown or unregistered legacy class ID: $classId',
      );
    }
    return className;
  }

  /// Deserializes registered objects from the Kryo binary stream.
  static dynamic readClassAndObject(KryoReader reader) {
    final String? className = readClassName(reader);
    if (className == null) {
      return null;
    }

    switch (className) {
      case 'Point':
        return LegacyPoint.deserialize(reader);
      case 'PointF':
        return LegacyPointF.deserialize(reader);
      case 'RectF':
        return LegacyRectF.deserialize(reader);
      case 'Paint':
        return LegacyPaint.deserialize(reader);
      case 'ColorHistory':
        return LegacyColorHistory.deserialize(reader);
      case 'FloatArray':
        return LegacyFloatArray.deserialize(reader).values;
      case 'StringArray':
        return LegacyStringArray.deserialize(reader).values;
      case 'SerializablePath':
        return LegacySerializablePath.deserialize(reader);
      case 'SerializablePathMove':
        return LegacySerializablePathMove.deserialize(reader);
      case 'SerializablePathLine':
        return LegacySerializablePathLine.deserialize(reader);
      case 'SerializablePathQuad':
        return LegacySerializablePathQuad.deserialize(reader);
      case 'SerializablePathRewind':
        return LegacySerializablePathRewind.deserialize(reader);
      case 'SerializablePathCube':
        return LegacySerializablePathCube.deserialize(reader);
      default:
        // Returns the class name to be handled dynamically by specific command parsers
        return className;
    }
  }
}
