import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart'
    show CommandFactory, DrawPathCommand;
import 'package:paintroid/io/serialization.dart';

class DrawPathCommandSerializer extends ProtoSerializerWithVersioning<
    DrawPathCommand, SerializableDrawPathCommand> {
  final PathSerializer _pathSerializer;
  final PaintSerializer _paintSerializer;
  final CommandFactory _commandFactory;

  const DrawPathCommandSerializer(
    super.version,
    this._pathSerializer,
    this._paintSerializer,
    this._commandFactory,
  );

  static final provider = Provider.family(
    (ref, int ver) => DrawPathCommandSerializer(
        ver,
        ref.watch(PathSerializer.provider(ver)),
        ref.watch(PaintSerializer.provider(ver)),
        ref.watch(CommandFactory.provider)),
  );

  @override
  final fromBytesToSerializable = SerializableDrawPathCommand.fromBuffer;

  @override
  DrawPathCommand deserializeWithLatestVersion(
      SerializableDrawPathCommand data) {
    final path = _pathSerializer.deserialize(data.path);
    final paint = _paintSerializer.deserialize(data.paint);
    return _commandFactory.createDrawPathCommand(path, paint);
  }

  @override
  SerializableDrawPathCommand serializeWithLatestVersion(
      DrawPathCommand object) {
    final sPaint = _paintSerializer.serializeWithLatestVersion(object.paint);
    final sPath = _pathSerializer.serializeWithLatestVersion(object.path);
    return SerializableDrawPathCommand(paint: sPaint, path: sPath);
  }
}
