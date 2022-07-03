import 'dart:typed_data';

import 'package:paintroid/command/command.dart';
import 'package:paintroid/data/serializable.dart';
import 'package:paintroid/data/src/serialization/serializer/graphic/paint_serializer.dart';
import 'package:paintroid/data/src/serialization/serializer/graphic/path_serializer.dart';

class DrawPathCommandSerializer
    implements ProtoSerializer<DrawPathCommand, SerializableDrawPathCommand> {
  final PathSerializer pathSerializer;
  final PaintSerializer paintSerializer;
  final CommandFactory commandFactory;

  const DrawPathCommandSerializer(
    this.pathSerializer,
    this.paintSerializer,
    this.commandFactory,
  );

  @override
  DrawPathCommand deserialize(Uint8List binary) {
    final serializable = SerializableDrawPathCommand.fromBuffer(binary);
    return deserializeFromProto(serializable);
  }

  @override
  DrawPathCommand deserializeFromProto(
      SerializableDrawPathCommand serializable) {
    final path = pathSerializer.deserializeFromProto(serializable.path);
    final paint = paintSerializer.deserializeFromProto(serializable.paint);
    return commandFactory.createDrawPathCommand(path, paint);
  }

  @override
  Uint8List serialize(DrawPathCommand object) =>
      convertToProtoSerializable(object).writeToBuffer();

  @override
  SerializableDrawPathCommand convertToProtoSerializable(
      DrawPathCommand object) {
    final sPaint = paintSerializer.convertToProtoSerializable(object.paint);
    final sPath = pathSerializer.convertToProtoSerializable(object.path);
    return SerializableDrawPathCommand(paint: sPaint, path: sPath);
  }
}
