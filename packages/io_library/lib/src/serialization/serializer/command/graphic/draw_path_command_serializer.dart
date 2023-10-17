import 'package:command/command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';

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
        ref.watch(commandFactoryProvider)),
  );

  @override
  final fromBytesToSerializable = SerializableDrawPathCommand.fromBuffer;

  @override
  Future<DrawPathCommand> deserializeWithLatestVersion(
      SerializableDrawPathCommand data) async {
    final path = await _pathSerializer.deserialize(data.path);
    final paint = await _paintSerializer.deserialize(data.paint);
    return _commandFactory.createDrawPathCommand(path, paint);
  }

  @override
  Future<SerializableDrawPathCommand> serializeWithLatestVersion(
      DrawPathCommand object) async {
    final sPaint =
        await _paintSerializer.serializeWithLatestVersion(object.paint);
    final sPath = await _pathSerializer.serializeWithLatestVersion(object.path);
    return SerializableDrawPathCommand()
      ..paint = sPaint
      ..path = sPath;
  }
}
