import 'package:paintroid/core/backward_compatibility/kryo_class_registry.dart';
import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacyCommandManagerModel {
  final dynamic initialCommand;
  final List<dynamic> commands;

  LegacyCommandManagerModel({
    required this.initialCommand,
    required this.commands,
  });

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
        final paint = KryoClassRegistry.readClassAndObject(reader);
        final path = KryoClassRegistry.readClassAndObject(reader);
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
        final position = KryoClassRegistry.readClassAndObject(reader);
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
      default:
        return {'type': className};
    }
  }
}
