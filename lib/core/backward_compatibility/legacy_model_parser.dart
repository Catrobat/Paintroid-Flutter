import 'dart:convert';
import 'dart:typed_data';
import 'package:paintroid/core/backward_compatibility/kryo_class_registry.dart';
import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/models.dart';

class LegacyCommandManagerModel {
  final dynamic initialCommand;
  final List<dynamic> commands;

  LegacyCommandManagerModel({
    required this.initialCommand,
    required this.commands,
  });

  /// Deserializes the CommandManagerModel structure from the Kryo binary reader.
  factory LegacyCommandManagerModel.deserialize(KryoReader reader) {
    final String? initClassName = KryoClassRegistry.readClassName(reader);
    if (initClassName == null) {
      throw FormatException(
        'Legacy CommandManagerModel initialCommand cannot be null.',
      );
    }
    final dynamic initialCommand = _deserializeCommand(initClassName, reader);

    final int size = reader.readInt32();

    final List<dynamic> commands = [];
    for (int i = 0; i < size; i++) {
      if (!reader.hasRemaining) {
        break;
      }
      final String? className = KryoClassRegistry.readClassName(reader);
      if (className != null) {
        commands.add(_deserializeCommand(className, reader));
      }
    }

    return LegacyCommandManagerModel(
      initialCommand: initialCommand,
      commands: commands,
    );
  }

  static dynamic _deserializeCommand(String className, KryoReader reader) {
    switch (className) {
      case 'SetDimensionCommand':
        final int width = reader.readInt32();
        final int height = reader.readInt32();
        return {
          'type': 'SetDimensionCommand',
          'width': width,
          'height': height,
        };
      case 'PathCommand':
        final paint = LegacyPaint.deserialize(reader);
        final path = LegacySerializablePath.deserialize(reader);
        return {'type': 'PathCommand', 'paint': paint, 'path': path};
      case 'AddEmptyLayerCommand':
        return {'type': 'AddEmptyLayerCommand'};
      case 'SelectLayerCommand':
        final int layerIndex = reader.readInt32();
        return {'type': 'SelectLayerCommand', 'layerIndex': layerIndex};
      case 'RemoveLayerCommand':
        final int layerIndex = reader.readInt32();
        return {'type': 'RemoveLayerCommand', 'layerIndex': layerIndex};
      case 'MergeLayersCommand':
        final int bottomLayerIndex = reader.readInt32();
        final int topLayerIndex = reader.readInt32();
        return {
          'type': 'MergeLayersCommand',
          'bottomLayerIndex': bottomLayerIndex,
          'topLayerIndex': topLayerIndex,
        };
      case 'ReorderLayersCommand':
        final int fromIndex = reader.readInt32();
        final int toIndex = reader.readInt32();
        return {
          'type': 'ReorderLayersCommand',
          'fromIndex': fromIndex,
          'toIndex': toIndex,
        };
      case 'LayerOpacityCommand':
        final int layerIndex = reader.readInt32();
        final double opacity = reader.readFloat();
        return {
          'type': 'LayerOpacityCommand',
          'layerIndex': layerIndex,
          'opacity': opacity,
        };
      case 'FlipCommand':
        final int flipDirection = reader.readInt32();
        return {'type': 'FlipCommand', 'flipDirection': flipDirection};
      case 'RotateCommand':
        final int rotateDirection = reader.readInt32();
        return {'type': 'RotateCommand', 'rotateDirection': rotateDirection};
      case 'CropCommand':
        final int coordinateXLeft = reader.readInt32();
        final int coordinateYTop = reader.readInt32();
        final int coordinateXRight = reader.readInt32();
        final int coordinateYBottom = reader.readInt32();
        final int maxResolution = reader.readInt32();
        return {
          'type': 'CropCommand',
          'coordinateXLeft': coordinateXLeft,
          'coordinateYTop': coordinateYTop,
          'coordinateXRight': coordinateXRight,
          'coordinateYBottom': coordinateYBottom,
          'maximumBitmapResolution': maxResolution,
        };
      case 'ResizeCommand':
        final int width = reader.readInt32();
        final int height = reader.readInt32();
        return {'type': 'ResizeCommand', 'width': width, 'height': height};
      case 'CutCommand':
        final position = LegacyPoint.deserialize(reader);
        final double width = reader.readFloat();
        final double height = reader.readFloat();
        final double rotation = reader.readFloat();
        return {
          'type': 'CutCommand',
          'position': position,
          'boxWidth': width,
          'boxHeight': height,
          'boxRotation': rotation,
        };
      case 'ResetCommand':
        return {'type': 'ResetCommand'};
      case 'SprayCommand':
        final sprayedPoints = LegacyFloatArray.deserialize(reader).values;
        final paint = LegacyPaint.deserialize(reader);
        return {
          'type': 'SprayCommand',
          'sprayedPoints': sprayedPoints,
          'paint': paint,
        };
      case 'PointCommand':
        final point = LegacyPoint.deserialize(reader);
        final paint = LegacyPaint.deserialize(reader);
        return {'type': 'PointCommand', 'point': point, 'paint': paint};
      case 'TextToolCommand':
        final text = LegacyStringArray.deserialize(reader).values;
        final paint = LegacyPaint.deserialize(reader);
        final offset = reader.readFloat();
        final width = reader.readFloat();
        final height = reader.readFloat();
        final position = LegacyPointF.deserialize(reader);
        final rotation = reader.readFloat();
        final typeface = LegacySerializableTypeface.deserialize(reader);
        return {
          'type': 'TextToolCommand',
          'multilineText': text,
          'paint': paint,
          'boxOffset': offset,
          'boxWidth': width,
          'boxHeight': height,
          'position': position,
          'rotation': rotation,
          'typeface': typeface,
        };
      case 'ClipboardCommand':
        final bitmapBytes = readPngBytes(reader);
        final coordinates = LegacyPoint.deserialize(reader);
        final width = reader.readFloat();
        final height = reader.readFloat();
        final rotation = reader.readFloat();
        return {
          'type': 'ClipboardCommand',
          'bitmap': bitmapBytes,
          'coordinates': coordinates,
          'width': width,
          'height': height,
          'rotation': rotation,
        };
      case 'SmudgePathCommand':
        final originalBitmap = readPngBytes(reader);
        final List<dynamic> pointPath = [];
        final size = reader.readInt32();
        for (int i = 0; i < size; i++) {
          pointPath.add(LegacyPointF.deserialize(reader));
        }
        final maxPressure = reader.readFloat();
        final maxSize = reader.readFloat();
        final minSize = reader.readFloat();
        return {
          'type': 'SmudgePathCommand',
          'originalBitmap': originalBitmap,
          'pointPath': pointPath,
          'maxPressure': maxPressure,
          'maxSize': maxSize,
          'minSize': minSize,
        };
      case 'ClippingCommand':
        final bitmap = readPngBytes(reader);
        final pathBitmap = readPngBytes(reader);
        return {
          'type': 'ClippingCommand',
          'bitmap': bitmap,
          'pathBitmap': pathBitmap,
        };
      case 'LoadLayerListCommand':
        final int size = reader.readInt32();
        final List<dynamic> layers = [];
        for (int i = 0; i < size; i++) {
          final bitmap = readPngBytes(reader);
          final opacity = reader.readInt32();
          layers.add({'bitmap': bitmap, 'opacity': opacity});
        }
        return {'type': 'LoadLayerListCommand', 'layers': layers};
      case 'GeometricFillCommand':
        final shape = KryoClassRegistry.readClassAndObject(reader);
        final pointX = reader.readInt32();
        final pointY = reader.readInt32();
        final rect = LegacyRectF.deserialize(reader);
        final rotation = reader.readFloat();
        final paint = LegacyPaint.deserialize(reader);
        return {
          'type': 'GeometricFillCommand',
          'shapeDrawable': shape,
          'pointX': pointX,
          'pointY': pointY,
          'boxRect': rect,
          'boxRotation': rotation,
          'paint': paint,
        };
      case 'FillCommand':
        final tolerance = reader.readFloat();
        final pixel = LegacyPoint.deserialize(reader);
        final paint = LegacyPaint.deserialize(reader);
        return {
          'type': 'FillCommand',
          'colorTolerance': tolerance,
          'clickedPixel': pixel,
          'paint': paint,
        };
      default:
        return {'type': className};
    }
  }

  static Uint8List readPngBytes(KryoReader reader) {
    final startPosition = reader.position;
    final signature = reader.readBytes(8);
    if (signature[0] != 0x89 ||
        signature[1] != 0x50 ||
        signature[2] != 0x4E ||
        signature[3] != 0x47 ||
        signature[4] != 0x0D ||
        signature[5] != 0x0A ||
        signature[6] != 0x1A ||
        signature[7] != 0x0A) {
      throw FormatException('Invalid PNG signature');
    }

    while (reader.hasRemaining) {
      final lengthBytes = reader.readBytes(4);
      final length = ByteData.sublistView(lengthBytes).getUint32(0, Endian.big);
      final typeBytes = reader.readBytes(4);
      final type = ascii.decode(typeBytes);

      // Skip chunk data and CRC
      reader.readBytes(length + 4);

      if (type == 'IEND') {
        break;
      }
    }
    final endPosition = reader.position;

    final currentPos = reader.position;
    reader.position = startPosition;
    final pngBytes = reader.readBytes(endPosition - startPosition);
    reader.position = currentPos;
    return pngBytes;
  }
}
